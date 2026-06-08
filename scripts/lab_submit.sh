#!/usr/bin/env bash
#
# lab_submit.sh — bundle your work for a lab into a single zip to hand in.
#
# Usage:
#     scripts/lab_submit.sh <day-number>        # e.g. scripts/lab_submit.sh 2
#     scripts/lab_submit.sh -h | --help
#
# What it collects, for the given lab day:
#   1. reflection.txt  — your short write-up. If it's missing, this script
#      creates a template and asks you to fill it in and re-run. It also
#      rejects an empty or one-line reflection (we expect a couple sentences).
#   2. Your modified / new HDL files (*.v and *.sv) in that day's folder.
#   3. A waveform image (SVG) rendered from every *.vcd produced by `make sim`.
#
# The result is  day<NN>_submission.zip  in the current directory.
#
set -euo pipefail

MIN_CHARS=80     # minimum non-whitespace characters of real reflection content
MIN_WORDS=15     # ...and at least this many words (a couple of sentences)

die()  { echo "lab_submit: $*" >&2; exit 1; }
note() { echo "==> $*"; }

# ---- args -----------------------------------------------------------------
[ $# -ge 1 ] || die "missing lab day number. Try: scripts/lab_submit.sh 2"
case "$1" in
  -h|--help) sed -n '2,20p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
esac
DAY="$1"
case "$DAY" in
  ''|*[!0-9]*) die "day must be a number (1-16), got '$DAY'." ;;
esac
DAY_PADDED=$(printf '%02d' "$DAY")

# ---- locate repo + lab folder ---------------------------------------------
command -v git >/dev/null 2>&1 || die "git is required (and you must run this inside the course repo)."
REPO=$(git rev-parse --show-toplevel 2>/dev/null) || die "not inside a git repository."
cd "$REPO"

# shellcheck disable=SC2206
MATCHES=( labs/week*_day"$DAY_PADDED" )
if [ ! -d "${MATCHES[0]}" ]; then
  die "no lab folder found for day $DAY (looked for labs/week*_day$DAY_PADDED)."
fi
[ "${#MATCHES[@]}" -eq 1 ] || die "ambiguous lab folder for day $DAY: ${MATCHES[*]}"
LAB="${MATCHES[0]}"
note "Lab day $DAY -> $LAB"

REFLECTION="$LAB/reflection.txt"

# ---- 1. reflection --------------------------------------------------------
if [ ! -f "$REFLECTION" ]; then
  cat > "$REFLECTION" <<EOF
# Lab $DAY Reflection
#
# Write a few sentences below these comment lines. Helpful prompts:
#   - What did you build, and what was the goal of the exercise(s)?
#   - What was the trickiest bug or concept, and how did you work through it?
#   - What would you do differently, or what are you still unsure about?
#
# Lines starting with '#' are ignored. Please write at least a couple of
# sentences of your own, then re-run:  scripts/lab_submit.sh $DAY

EOF
  note "Created $REFLECTION."
  echo ""
  echo "    Open it, write a couple of sentences, then re-run:"
  echo "        scripts/lab_submit.sh $DAY"
  echo ""
  exit 1
fi

# Measure only real content: drop comment (#) and blank lines.
CONTENT=$(grep -vE '^[[:space:]]*#' "$REFLECTION" | sed '/^[[:space:]]*$/d' || true)
CHARS=$(printf '%s' "$CONTENT" | tr -d '[:space:]' | wc -c | tr -d ' ')
WORDS=$(printf '%s' "$CONTENT" | wc -w | tr -d ' ')

if [ "$CHARS" -lt "$MIN_CHARS" ] || [ "$WORDS" -lt "$MIN_WORDS" ]; then
  echo ""
  echo "lab_submit: your reflection looks too short ($WORDS words, $CHARS characters)." >&2
  echo "            We're expecting at least a couple of sentences" \
       "(>= $MIN_WORDS words)." >&2
  echo "            Edit $REFLECTION and re-run: scripts/lab_submit.sh $DAY" >&2
  echo ""
  exit 1
fi
note "Reflection OK ($WORDS words)."

# ---- 2. modified / new HDL files ------------------------------------------
# Tracked files that differ from HEAD (staged or unstaged) + untracked files
# that aren't gitignored. Restricted to this lab folder, filtered to HDL.
hdl_files() {
  {
    git diff --name-only HEAD -- "$LAB" 2>/dev/null || true
    git ls-files --others --exclude-standard -- "$LAB" 2>/dev/null || true
  } | grep -iE '\.(v|sv)$' | sort -u
}
HDL=()
while IFS= read -r f; do [ -n "$f" ] && HDL+=("$f"); done < <(hdl_files)

if [ "${#HDL[@]}" -eq 0 ]; then
  die "no modified or new .v/.sv files found under $LAB.
            Did you edit the starter files? (If you committed your work,
            this looks at uncommitted changes — leave your edits uncommitted,
            or copy them back into the working tree before submitting.)"
fi
note "HDL files (${#HDL[@]}):"
printf '      %s\n' "${HDL[@]}"

# ---- 3. waveform images from VCDs -----------------------------------------
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
WAVE_DIR="$TMP/waveforms"
mkdir -p "$WAVE_DIR"

VCDS=()
while IFS= read -r f; do [ -n "$f" ] && VCDS+=("$f"); done \
  < <(find "$LAB" -name '*.vcd' -type f | sort)
WAVES=()
if [ "${#VCDS[@]}" -eq 0 ]; then
  echo "lab_submit: WARNING — no .vcd files found under $LAB." >&2
  echo "            Run 'make exN_sim' (or 'make sim') first to generate" \
       "a waveform." >&2
  echo "            Bundling without a waveform image." >&2
else
  for vcd in "${VCDS[@]}"; do
    # name the SVG after the exercise dir + vcd basename to avoid collisions
    rel=$(echo "${vcd#"$LAB"/}" | tr '/' '_')
    svg="$WAVE_DIR/${rel%.vcd}.svg"
    if python3 "$REPO/scripts/vcd2svg.py" "$vcd" -o "$svg" >/dev/null 2>&1; then
      WAVES+=("$svg")
      note "Rendered waveform: ${vcd#"$REPO"/}"
    else
      echo "lab_submit: WARNING — could not render $vcd; skipping." >&2
    fi
  done
fi

# ---- 4. write a manifest --------------------------------------------------
MANIFEST="$TMP/SUBMISSION.txt"
{
  echo "Lab day:    $DAY  ($LAB)"
  echo "Student:    $(git config user.name 2>/dev/null || echo '?') <$(git config user.email 2>/dev/null || echo '?')>"
  echo "Created:    $(date '+%Y-%m-%d %H:%M:%S %z')"
  echo "Commit:     $(git rev-parse --short HEAD 2>/dev/null || echo '?')"
  echo ""
  echo "HDL files:"
  printf '  %s\n' "${HDL[@]}"
  echo ""
  echo "Waveforms:"
  if [ "${#WAVES[@]}" -gt 0 ]; then
    for w in "${WAVES[@]}"; do echo "  waveforms/$(basename "$w")"; done
  else
    echo "  (none)"
  fi
} > "$MANIFEST"

# ---- 5. build the zip (via python stdlib — no zip/tar binary needed) ------
OUT="$REPO/day${DAY_PADDED}_submission.zip"
MAPPING="$TMP/mapping.tsv"
: > "$MAPPING"
printf '%s\tSUBMISSION.txt\n' "$MANIFEST" >> "$MAPPING"
printf '%s\treflection.txt\n' "$REFLECTION" >> "$MAPPING"
for f in "${HDL[@]}"; do
  printf '%s\tsources/%s\n' "$REPO/$f" "${f#"$LAB"/}" >> "$MAPPING"
done
if [ "${#WAVES[@]}" -gt 0 ]; then
  for w in "${WAVES[@]}"; do
    printf '%s\twaveforms/%s\n' "$w" "$(basename "$w")" >> "$MAPPING"
  done
fi

python3 - "$OUT" "$MAPPING" <<'PY'
import sys, zipfile
out, mapping = sys.argv[1], sys.argv[2]
with zipfile.ZipFile(out, "w", zipfile.ZIP_DEFLATED) as z:
    for line in open(mapping):
        line = line.rstrip("\n")
        if not line:
            continue
        src, arc = line.split("\t", 1)
        z.write(src, arc)
PY

echo ""
note "Wrote $OUT"
echo "    Contents:"
python3 -c "import zipfile,sys; [print('      '+n) for n in zipfile.ZipFile(sys.argv[1]).namelist()]" "$OUT"
echo ""
echo "    Hand in: $OUT"
