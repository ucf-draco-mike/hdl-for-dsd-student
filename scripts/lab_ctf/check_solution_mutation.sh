#!/usr/bin/env bash
# check_solution_mutation.sh — mutation-testing self-check (flagless) for
# testbench-writing exercises.
#
# The student writes the *testbench*; the DUT is provided. This runs the
# student's testbench against:
#   - the provided good DUT  (baseline)
#   - a set of seeded mutant DUTs (one injected bug each), shipped in plaintext
#     under solution/mutants/<bug>/
# and PASSES only if the student's testbench DISTINGUISHES every mutant from the
# good DUT (i.e. actually catches each bug). A do-nothing testbench produces
# identical output on every variant and fails.
#
# Invoked automatically by check_solution.sh when solution/mutants/ exists.
# Run from inside an exercise's starter/ dir.

set -uo pipefail

STARTER_DIR=$(pwd)
SOLN_DIR="$(cd .. && pwd)/solution"
SHARED_LIB="$STARTER_DIR/../../../../shared/lib"

[[ -d "$SOLN_DIR/mutants" ]] || { echo "no mutants dir at $SOLN_DIR/mutants" >&2; exit 1; }

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

# Split the student's starter sources into testbench(es) and DUT(s).
shopt -s nullglob
tb_files=(); dut_files=()
for f in "$STARTER_DIR"/*.v "$STARTER_DIR"/*.sv "$STARTER_DIR"/*.svh "$STARTER_DIR"/*.vh "$STARTER_DIR"/*.hex; do
    b=$(basename "$f")
    if [[ "$b" == tb_* ]]; then tb_files+=("$f"); else dut_files+=("$f"); fi
done
if [[ ${#tb_files[@]} -eq 0 ]]; then
    echo "❌ No testbench (tb_*.v) found in $STARTER_DIR — this exercise grades your testbench." >&2
    exit 1
fi
if [[ ${#dut_files[@]} -eq 0 ]]; then
    echo "❌ No DUT sources found in $STARTER_DIR" >&2
    exit 1
fi

# The seeded mutant DUTs ship in plaintext — copy them into the scratch tree.
cp -r "$SOLN_DIR/mutants" "$work/mutants"

# run_variant <dut files...> : compile the student's testbench against the given
# DUT files and echo vvp stdout, or "__CF__" on compile failure.
run_variant() {
    local w; w=$(mktemp -d -p "$work"); mkdir -p "$w/build"
    cp "${tb_files[@]}" "$w/" 2>/dev/null
    cp "$@" "$w/" 2>/dev/null
    if [[ -d "$SHARED_LIB" ]]; then
        local lm; lm=$(grep -h -E '^\s*module\s+\w+' "$w"/*.v "$w"/*.sv 2>/dev/null \
                       | sed -E 's/^\s*module\s+(\w+).*/\1/' | sort -u)
        local lf lb sm m cl
        for lf in "$SHARED_LIB"/*.v "$SHARED_LIB"/*.sv "$SHARED_LIB"/*.vh "$SHARED_LIB"/*.svh; do
            [[ -f "$lf" ]] || continue; lb=$(basename "$lf"); [[ "$lb" == tb_* ]] && continue
            [[ -e "$w/$lb" ]] && continue
            sm=$(grep -h -E '^\s*module\s+\w+' "$lf" 2>/dev/null | sed -E 's/^\s*module\s+(\w+).*/\1/' | sort -u)
            cl=0; for m in $sm; do echo "$lm" | grep -qx "$m" && { cl=1; break; }; done
            [[ $cl -eq 1 ]] && continue; cp "$lf" "$w/$lb"
        done
    fi
    local tbs duts
    tbs=$(cd "$w" && ls tb_*.v tb_*.sv 2>/dev/null | tr '\n' ' ')
    duts=$(cd "$w" && ls *.v *.sv 2>/dev/null | grep -v '^tb_' | tr '\n' ' ')
    if ! ( cd "$w" && iverilog -g2012 -o sim.vvp $tbs $duts ) >/dev/null 2>&1; then
        echo "__CF__"; return
    fi
    ( cd "$w" && vvp sim.vvp 2>/dev/null )
}

# Baseline: the student's testbench against the (unmodified) good DUT.
good_out=$(run_variant "${dut_files[@]}")
if [[ "$good_out" == "__CF__" ]]; then
    echo "❌ Your testbench does not compile against the provided DUT."
    exit 1
fi

# For each mutant, swap in the mutant DUT (matching by filename) and see whether
# the student's testbench produces different output — i.e. catches the bug.
ntot=0; ncaught=0; missed=""
for md in $(ls -d "$work"/mutants/*/ 2>/dev/null | sort); do
    name=$(basename "$md")
    ntot=$((ntot + 1))
    declare -A overridden=()
    for mf in "$md"*.v "$md"*.sv; do [[ -f "$mf" ]] && overridden[$(basename "$mf")]=1; done
    files=()
    for d in "${dut_files[@]}"; do
        [[ -n "${overridden[$(basename "$d")]:-}" ]] && continue
        files+=("$d")
    done
    for mf in "$md"*.v "$md"*.sv; do [[ -f "$mf" ]] && files+=("$mf"); done
    mout=$(run_variant "${files[@]}")
    if [[ "$mout" != "$good_out" && "$mout" != "__CF__" ]]; then
        ncaught=$((ncaught + 1))
    else
        missed+=" $name"
    fi
    unset overridden
done

if [[ $ntot -gt 0 && $ncaught -eq $ntot ]]; then
    echo ""
    echo "✅ PASS — your testbench caught all $ntot seeded bugs."
else
    echo ""
    echo "❌ Your testbench compiles and runs, but it missed $((ntot - ncaught)) of"
    echo "   $ntot seeded bug(s):$missed"
    echo "   It produced the *same* output whether the DUT was correct or broken."
    echo "   Add checks that exercise the untested behaviour, then re-run."
    exit 1
fi
