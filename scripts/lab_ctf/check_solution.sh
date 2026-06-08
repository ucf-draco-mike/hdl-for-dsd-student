#!/usr/bin/env bash
# check_solution.sh — `make test` self-check (flagless).
#
# Compiles the student's DUT against the published, self-checking testbench and
# reports PASS/FAIL by comparing its output to the reference DUT's output under
# the same testbench. The reference solution ships in plaintext under
# solution/ref/, so no keys or unlocking are involved.
#
# Run from inside an exercise's starter/ directory. Assumes ../solution/ holds:
#   tb/        the published testbench(es)
#   ref/       the reference DUT (plaintext)
#
# Testbench-writing exercises (where the student writes the testbench) ship
# seeded mutants under solution/mutants/ and are graded by
# check_solution_mutation.sh, which this script delegates to.

set -uo pipefail

STARTER_DIR=$(pwd)
SOLN_DIR="$(cd .. && pwd)/solution"
SHARED_LIB="$STARTER_DIR/../../../../shared/lib"

if [[ -d "$SOLN_DIR/mutants" ]]; then
    exec bash "$(dirname "${BASH_SOURCE[0]}")/check_solution_mutation.sh" "$@"
fi

[[ -d "$SOLN_DIR/tb" ]]  || { echo "no testbench dir at $SOLN_DIR/tb" >&2; exit 1; }
[[ -d "$SOLN_DIR/ref" ]] || { echo "no reference dir at $SOLN_DIR/ref" >&2; exit 1; }

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

# surface_shared <workdir> — copy non-colliding shared/lib helpers (uart_tx.v,
# debounce.v, hex_to_7seg.v, …) into <workdir> for DUTs that instantiate them.
# Never overwrite a local file or one whose module name the DUT already declares.
surface_shared() {
    local w="$1"
    [[ -d "$SHARED_LIB" ]] || return 0
    local local_mods f base shared_mods m clash
    local_mods=$(grep -h -E '^\s*module\s+\w+' "$w"/*.v "$w"/*.sv 2>/dev/null \
                 | sed -E 's/^\s*module\s+(\w+).*/\1/' | sort -u)
    for f in "$SHARED_LIB"/*.v "$SHARED_LIB"/*.sv "$SHARED_LIB"/*.vh "$SHARED_LIB"/*.svh; do
        [[ -f "$f" ]] || continue
        base=$(basename "$f"); [[ "$base" == tb_* ]] && continue
        [[ -e "$w/$base" ]] && continue
        shared_mods=$(grep -h -E '^\s*module\s+\w+' "$f" 2>/dev/null \
                      | sed -E 's/^\s*module\s+(\w+).*/\1/' | sort -u)
        clash=0
        for m in $shared_mods; do echo "$local_mods" | grep -qx "$m" && { clash=1; break; }; done
        [[ $clash -eq 1 ]] && continue
        cp "$f" "$w/$base"
    done
}

# build_run <outfile> <dut files…> — compile the published TB against the given
# DUT files and capture vvp stdout into <outfile>. Returns 1 on compile failure
# (log left at $work/compile.log).
build_run() {
    local outfile="$1"; shift
    local w; w=$(mktemp -d -p "$work"); mkdir -p "$w/build"
    cp "$SOLN_DIR"/tb/* "$w/" 2>/dev/null
    cp "$@" "$w/" 2>/dev/null
    surface_shared "$w"
    # solution/tb/ holds testbench files exclusively; their names don't always
    # start with tb_, so use the directory listing as ground truth.
    local tb_list dut_list tb_name
    tb_list=$(cd "$SOLN_DIR/tb" && ls *.v *.sv 2>/dev/null | tr '\n' ' ')
    dut_list=$(cd "$w" && ls *.v *.sv 2>/dev/null | tr '\n' ' ')
    for tb_name in $tb_list; do
        dut_list=$(echo "$dut_list" | tr ' ' '\n' | grep -vx "$tb_name" | tr '\n' ' ')
    done
    if ! ( cd "$w" && iverilog -g2012 -o sim.vvp $tb_list $dut_list ) >"$w/compile.log" 2>&1; then
        cp "$w/compile.log" "$work/compile.log"
        return 1
    fi
    ( cd "$w" && vvp sim.vvp 2>/dev/null ) > "$outfile"
    return 0
}

# Student DUT = every non-testbench source in starter/.
shopt -s nullglob
student_srcs=()
for f in "$STARTER_DIR"/*.v "$STARTER_DIR"/*.sv "$STARTER_DIR"/*.svh "$STARTER_DIR"/*.vh "$STARTER_DIR"/*.hex; do
    [[ "$(basename "$f")" == tb_* ]] && continue
    student_srcs+=("$f")
done
[[ ${#student_srcs[@]} -gt 0 ]] || { echo "no source files found in $STARTER_DIR" >&2; exit 1; }

# Reference DUT = solution/ref/*.
ref_srcs=("$SOLN_DIR"/ref/*)

if ! build_run "$work/student.out" "${student_srcs[@]}"; then
    echo "❌ Compile failed:"
    sed 's/^/   /' "$work/compile.log"
    exit 1
fi
if ! build_run "$work/ref.out" "${ref_srcs[@]}"; then
    echo "⚠️  Could not build the reference DUT in $SOLN_DIR/ref — please report this." >&2
    exit 1
fi

# Show the student's testbench run.
cat "$work/student.out"

if diff -q "$work/student.out" "$work/ref.out" >/dev/null 2>&1; then
    echo ""
    echo "✅ PASS — your output matches the reference."
else
    echo ""
    echo "❌ Output differs from the reference. Keep iterating — your DUT"
    echo "   compiles, but its behaviour under the testbench differs from the"
    echo "   reference. The worked answer is in ../solution/ref/ if you get stuck."
    exit 1
fi
