#!/usr/bin/env python3
"""Render a VCD waveform dump to a standalone SVG image.

Pure standard-library — no external packages, no GUI, no display server — so it
runs identically on Linux, macOS and WSL2 (GTKWave can't export images
headlessly in a portable way). The SVG opens in any web browser or image
viewer and stays crisp at any zoom.

Usage:
    python3 scripts/vcd2svg.py dump.vcd [-o dump.svg] [--max-width N]

Renders one lane per signal: scalar (1-bit) signals as a digital high/low
trace, multi-bit buses as a value-labelled band. Unknown ('x') and high-Z
('z') regions are shaded.
"""
from __future__ import annotations

import argparse
import html
import os
import re
import sys

# ---- layout constants (px) ------------------------------------------------
LABEL_W = 180
LANE_H = 36
LANE_GAP = 8
TOP_PAD = 40
BOT_PAD = 20
TRACE_PAD = 6          # vertical padding inside a lane for the trace
DEFAULT_MAX_W = 1600
MIN_PLOT_W = 400


class Signal:
    __slots__ = ("ident", "names", "width", "changes")

    def __init__(self, ident: str, name: str, width: int):
        self.ident = ident
        self.names = [name]
        self.width = width
        self.changes: list[tuple[int, str]] = []  # (time, value)


def parse_vcd(path: str):
    signals: dict[str, Signal] = {}
    timescale = ""
    scope: list[str] = []
    in_defs = True
    cur_time = 0
    saw_time = False

    var_re = re.compile(r"\$var\s+\S+\s+(\d+)\s+(\S+)\s+(.+?)\s*\$end")

    with open(path, errors="ignore") as fh:
        for raw in fh:
            line = raw.strip()
            if not line:
                continue

            if in_defs:
                if line.startswith("$timescale"):
                    # may be on same line or next; grab digits+unit if present
                    m = re.search(r"\$timescale\s+(.+?)\s*\$end", line)
                    if m:
                        timescale = m.group(1).strip()
                    continue
                if line.startswith("$scope"):
                    parts = line.split()
                    if len(parts) >= 3:
                        scope.append(parts[2])
                    continue
                if line.startswith("$upscope"):
                    if scope:
                        scope.pop()
                    continue
                if line.startswith("$var"):
                    m = var_re.search(line)
                    if m:
                        width = int(m.group(1))
                        ident = m.group(2)
                        name = m.group(3).strip()
                        # collapse "name [3:0]" -> "name[3:0]"
                        name = re.sub(r"\s+\[", "[", name)
                        full = ".".join(scope + [name]) if scope else name
                        if ident in signals:
                            signals[ident].names.append(full)
                        else:
                            signals[ident] = Signal(ident, full, width)
                    continue
                if line.startswith("$enddefinitions"):
                    in_defs = False
                    continue
                continue

            # ---- value-change section ----
            c = line[0]
            if c == "#":
                cur_time = int(line[1:])
                saw_time = True
                continue
            if c in "01xXzZ":
                ident = line[1:]
                val = c.lower()
                sig = signals.get(ident)
                if sig is not None:
                    sig.changes.append((cur_time if saw_time else 0, val))
                continue
            if c in "bB":
                # vector: b<bits> <ident>
                parts = line.split()
                if len(parts) == 2:
                    bits, ident = parts[0][1:], parts[1]
                    sig = signals.get(ident)
                    if sig is not None:
                        sig.changes.append((cur_time if saw_time else 0, bits.lower()))
                continue
            if c in "rR":
                parts = line.split()
                if len(parts) == 2:
                    ident = parts[1]
                    sig = signals.get(ident)
                    if sig is not None:
                        sig.changes.append((cur_time if saw_time else 0, parts[0][1:]))
                continue
            # ignore $dumpvars / $dumpon / $end / $comment etc.

    return signals, timescale, cur_time


def bits_to_hex(bits: str) -> str:
    if any(ch in "xz" for ch in bits):
        # mixed unknown — show as-is if short, else collapse
        return bits if len(bits) <= 8 else "x.."
    try:
        return hex(int(bits, 2))
    except ValueError:
        return bits


def svg_escape(s: str) -> str:
    return html.escape(s, quote=True)


def render(signals: dict[str, Signal], timescale: str, tmax: int,
           max_width: int) -> str:
    sigs = [s for s in signals.values() if s.changes]
    if not sigs:
        sigs = list(signals.values())
    n = len(sigs)
    tmax = max(tmax, 1)

    plot_w = max(MIN_PLOT_W, min(max_width, 2 * tmax + 200))
    width = LABEL_W + plot_w + 20
    height = TOP_PAD + n * (LANE_H + LANE_GAP) + BOT_PAD

    def x_of(t: int) -> float:
        return LABEL_W + (t / tmax) * (plot_w - 10)

    out = []
    out.append(
        f'<svg xmlns="http://www.w3.org/2000/svg" width="{width}" '
        f'height="{height}" viewBox="0 0 {width} {height}" '
        f'font-family="monospace" font-size="12">'
    )
    out.append(f'<rect width="{width}" height="{height}" fill="#1e1e2e"/>')
    title = "VCD waveform"
    if timescale:
        title += f"  (timescale {svg_escape(timescale)}, t=0..{tmax})"
    out.append(
        f'<text x="10" y="22" fill="#cdd6f4" font-size="14" '
        f'font-weight="bold">{svg_escape(title)}</text>'
    )
    # vertical separator between labels and traces
    out.append(
        f'<line x1="{LABEL_W}" y1="{TOP_PAD-6}" x2="{LABEL_W}" '
        f'y2="{height-BOT_PAD}" stroke="#45475a" stroke-width="1"/>'
    )

    for i, sig in enumerate(sigs):
        top = TOP_PAD + i * (LANE_H + LANE_GAP)
        hi = top + TRACE_PAD
        lo = top + LANE_H - TRACE_PAD
        mid = (hi + lo) / 2
        label = sig.names[0]
        if len(label) > 24:
            label = "…" + label[-23:]
        out.append(
            f'<text x="10" y="{mid+4:.0f}" fill="#a6adc8">'
            f'{svg_escape(label)}</text>'
        )
        # lane baseline
        out.append(
            f'<line x1="{LABEL_W}" y1="{lo:.1f}" x2="{LABEL_W+plot_w-10}" '
            f'y2="{lo:.1f}" stroke="#313244" stroke-width="1"/>'
        )

        changes = sorted(sig.changes)
        # ensure a segment extends to tmax
        segs = []
        for j, (t, v) in enumerate(changes):
            t_end = changes[j + 1][0] if j + 1 < len(changes) else tmax
            if t_end < t:
                t_end = t
            segs.append((t, t_end, v))

        if sig.width == 1:
            out.extend(_draw_scalar(segs, x_of, hi, lo))
        else:
            out.extend(_draw_bus(segs, x_of, hi, lo, mid))

    out.append("</svg>")
    return "\n".join(out)


def _draw_scalar(segs, x_of, hi, lo):
    parts = []
    prev_y = lo
    prev_x = x_of(0)
    for (t0, t1, v) in segs:
        x0, x1 = x_of(t0), x_of(t1)
        if v in ("x", "z"):
            color = "#f38ba8" if v == "x" else "#f9e2af"
            parts.append(
                f'<rect x="{x0:.1f}" y="{hi:.1f}" width="{max(0,x1-x0):.1f}" '
                f'height="{lo-hi:.1f}" fill="{color}" fill-opacity="0.25"/>'
            )
            y = (hi + lo) / 2
            parts.append(
                f'<line x1="{x0:.1f}" y1="{y:.1f}" x2="{x1:.1f}" y2="{y:.1f}" '
                f'stroke="{color}" stroke-width="2"/>'
            )
            prev_y = y
            prev_x = x1
            continue
        y = hi if v == "1" else lo
        # vertical edge from previous level
        if y != prev_y:
            parts.append(
                f'<line x1="{x0:.1f}" y1="{prev_y:.1f}" x2="{x0:.1f}" '
                f'y2="{y:.1f}" stroke="#89b4fa" stroke-width="2"/>'
            )
        parts.append(
            f'<line x1="{x0:.1f}" y1="{y:.1f}" x2="{x1:.1f}" y2="{y:.1f}" '
            f'stroke="#89b4fa" stroke-width="2"/>'
        )
        prev_y = y
        prev_x = x1
    return parts


def _draw_bus(segs, x_of, hi, lo, mid):
    parts = []
    for (t0, t1, v) in segs:
        x0, x1 = x_of(t0), x_of(t1)
        w = max(0.0, x1 - x0)
        slant = min(5.0, w / 2)
        unknown = any(ch in "xz" for ch in v)
        stroke = "#f38ba8" if unknown else "#a6e3a1"
        # hexagon-ish band
        pts = (
            f"{x0:.1f},{mid:.1f} {x0+slant:.1f},{hi:.1f} "
            f"{x1-slant:.1f},{hi:.1f} {x1:.1f},{mid:.1f} "
            f"{x1-slant:.1f},{lo:.1f} {x0+slant:.1f},{lo:.1f}"
        )
        parts.append(
            f'<polygon points="{pts}" fill="none" stroke="{stroke}" '
            f'stroke-width="1.5"/>'
        )
        if w > 24:
            label = bits_to_hex(v)
            parts.append(
                f'<text x="{(x0+x1)/2:.1f}" y="{mid+4:.0f}" '
                f'text-anchor="middle" fill="#cdd6f4">{svg_escape(label)}</text>'
            )
    return parts


def main(argv):
    ap = argparse.ArgumentParser(description="Render a VCD to an SVG waveform.")
    ap.add_argument("vcd")
    ap.add_argument("-o", "--out", help="output SVG path (default: <vcd>.svg)")
    ap.add_argument("--max-width", type=int, default=DEFAULT_MAX_W)
    args = ap.parse_args(argv[1:])

    if not os.path.isfile(args.vcd):
        print(f"vcd2svg: no such file: {args.vcd}", file=sys.stderr)
        return 1

    signals, timescale, tmax = parse_vcd(args.vcd)
    if not signals:
        print(f"vcd2svg: no signals found in {args.vcd}", file=sys.stderr)
        return 1

    out = args.out or (os.path.splitext(args.vcd)[0] + ".svg")
    svg = render(signals, timescale, tmax, args.max_width)
    with open(out, "w") as fh:
        fh.write(svg)
    print(out)
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
