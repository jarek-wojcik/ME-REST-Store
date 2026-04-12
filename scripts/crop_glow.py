#!/usr/bin/env python3
"""
Crop *Glow.png files in the SP characters directory.

Usage:
    python crop_glow.py --left 0 --right 10 --top 5 --bottom 0
    python crop_glow.py --left 0 --right 10 --top 5 --bottom 0 --pattern "James*Glow.png"

Crop values are percentages (0 = no crop for that side).
Output files are saved alongside originals as *GlowCropped.png.
"""

import argparse
import re
import sys
from pathlib import Path

try:
    from PIL import Image
except ImportError:
    sys.exit("Pillow is required: pip install Pillow")

SP_DIR = Path(__file__).resolve().parent.parent / "SFS_Core_ASI" / "SFSWebserver" / "static" / "assets" / "characters" / "SP"
GLOW_PATTERN = re.compile(r"^(.+?)(\d+)Glow\.png$", re.IGNORECASE)


def crop_image(src: Path, left: float, right: float, top: float, bottom: float) -> Path:
    with Image.open(src) as img:
        w, h = img.size
        x0 = int(w * left / 100)
        y0 = int(h * top / 100)
        x1 = w - int(w * right / 100)
        y1 = h - int(h * bottom / 100)
        cropped = img.crop((x0, y0, x1, y1))

    stem = src.stem  # e.g. "James0Glow"
    out_path = src.with_name(stem + "Cropped.png")
    cropped.save(out_path)
    return out_path


def main():
    parser = argparse.ArgumentParser(description="Crop *Glow.png SP character images by percentage.")
    parser.add_argument("--left",   type=float, default=0, help="Percent to crop from the left   (default: 0)")
    parser.add_argument("--right",  type=float, default=0, help="Percent to crop from the right  (default: 0)")
    parser.add_argument("--top",    type=float, default=0, help="Percent to crop from the top    (default: 0)")
    parser.add_argument("--bottom", type=float, default=0, help="Percent to crop from the bottom (default: 0)")
    parser.add_argument("--pattern", type=str, default=None,
                        help="Optional glob pattern to restrict which files are processed, e.g. 'James*Glow.png'")
    parser.add_argument("--dir", type=Path, default=SP_DIR,
                        help=f"Directory containing SP Glow images (default: {SP_DIR})")
    args = parser.parse_args()

    sp_dir: Path = args.dir
    if not sp_dir.is_dir():
        sys.exit(f"Directory not found: {sp_dir}")

    glob = args.pattern if args.pattern else "*Glow.png"
    candidates = sorted(sp_dir.glob(glob))

    # Filter to only files matching the {name}{number}Glow.png pattern
    # (skip already-cropped files like *GlowCropped.png)
    files = [f for f in candidates if GLOW_PATTERN.match(f.name)]

    if not files:
        sys.exit(f"No matching Glow files found in {sp_dir}")

    for f in files:
        out = crop_image(f, args.left, args.right, args.top, args.bottom)
        print(f"  {f.name}  ->  {out.name}")

    print(f"\nDone. {len(files)} file(s) cropped.")


if __name__ == "__main__":
    main()
