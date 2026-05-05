# XeLaTeX Compile Guide — KOMA AI Chief Keynote 2026

## Quick Start

```bash
xelatex -interaction=nonstopmode main.tex
xelatex -interaction=nonstopmode main.tex   # second pass for TOC/references
```

Output: `main.pdf` (56 slides, 16:9 Beamer, Warsaw theme)

---

## Why XeLaTeX (not pdfLaTeX)

| Feature | pdfLaTeX | XeLaTeX |
|---|---|---|
| Traditional Chinese (繁體中文) | ✗ | ✓ via `xeCJK` |
| System fonts (Songti TC, etc.) | ✗ | ✓ via `fontspec` |
| SVG inclusion | ✗ | ✓ |

---

## First-Time Setup: SVG → PDF Conversion

The `svg` package requires Inkscape to convert `.svg` files at compile time.
If Inkscape is unavailable (or broken), pre-convert with `rsvg-convert`:

```bash
# Install rsvg-convert (macOS)
brew install librsvg

# Convert all SVGs to PDF (one-time, stores in svg-inkscape/)
mkdir -p svg-inkscape
for f in *.svg; do
    base="${f%.svg}"
    rsvg-convert -f pdf -o "svg-inkscape/${base}_svg-tex.pdf" "$f"
done
```

Then generate the companion `.pdf_tex` wrapper files:

```bash
python3 << 'EOF'
import os, re, xml.etree.ElementTree as ET

svg_dir = '.'
out_dir = 'svg-inkscape'

def get_svg_dims(path):
    try:
        root = ET.parse(path).getroot()
        vb = root.get('viewBox')
        if vb:
            parts = vb.strip().split()
            if len(parts) == 4:
                return float(parts[2]), float(parts[3])
        def strip_unit(s):
            return float(re.sub(r'[a-z%]', '', s)) if s else 100.0
        return strip_unit(root.get('width','100')), strip_unit(root.get('height','100'))
    except:
        return 100.0, 100.0

template = r"""\begingroup%
  \makeatletter%
  \providecommand\color[2][]{{}}%
  \providecommand\transparent[1]{{}}%
  \providecommand\rotatebox[2]{{#2}}%
  \ifx\svgwidth\undefined%
    \setlength{{\unitlength}}{{{w:.4f}bp}}%
    \ifx\svgscale\undefined\relax\else
      \setlength{{\unitlength}}{{\unitlength * \real{{\svgscale}}}}\fi%
  \else\setlength{{\unitlength}}{{\svgwidth}}\fi%
  \global\let\svgwidth\undefined%
  \global\let\svgscale\undefined%
  \makeatother%
  \begin{{picture}}(1,{ratio:.6f})%
    \put(0,0){{\includegraphics[width=\unitlength,page=1]{{{pdf}}}}}%
  \end{{picture}}%
\endgroup%
"""

for fname in os.listdir(svg_dir):
    if not fname.endswith('.svg'):
        continue
    base = fname[:-4]
    pdf_path = os.path.abspath(os.path.join(out_dir, base + '_svg-tex.pdf'))
    tex_path = os.path.join(out_dir, base + '_svg-tex.pdf_tex')
    if not os.path.exists(pdf_path):
        continue
    w, h = get_svg_dims(os.path.join(svg_dir, fname))
    with open(tex_path, 'w') as f:
        f.write(template.format(w=w, ratio=h/w if w>0 else 1.0, pdf=pdf_path))
    print(f'OK: {base}')
EOF
```

After this, `xelatex main.tex` will find all SVGs without error.

---

## Font Requirements

The project uses **Songti TC** (宋體-繁), a Traditional Chinese serif font
bundled with macOS.

```latex
\setCJKmainfont{Songti TC}
```

**On Linux / Overleaf:** substitute with an available TC font, e.g.:
```latex
\setCJKmainfont{AR PL UMing TW MBE}   % requires texlive-fonts-extra
% or
\setCJKmainfont{Noto Serif CJK TC}    % requires noto-cjk package
```

Check available fonts: `fc-list :lang=zh | grep -i TC`

---

## Full Rebuild (clean + compile)

```bash
# Remove build artifacts
rm -f *.aux *.log *.out *.fls *.fdb_latexmk *.toc *.nav *.snm *.vrb

# Compile (two passes for stable cross-references)
xelatex -interaction=nonstopmode main.tex
xelatex -interaction=nonstopmode main.tex
```

---

## Using latexmk (recommended for automation)

```bash
# Install latexmk if needed: brew install latexmk
latexmk -xelatex -interaction=nonstopmode main.tex

# Clean auxiliary files (keep PDF)
latexmk -c

# Full clean including PDF
latexmk -C
```

---

## Project Structure

```
KOMA_AI_chief_keynote_2026May/
├── main.tex              # Source — single-file Beamer presentation
├── COMPILE.md            # This guide
├── *.svg                 # Vector logos and illustrations
├── *.jpg / *.jpeg / *.png  # Photo assets
├── svg-inkscape/         # Auto-generated SVG→PDF intermediates (gitignored)
└── main.pdf              # Output (gitignored — rebuild locally)
```

---

## Slide Overview (56 slides)

| Slides | Section |
|---|---|
| 1 | Title — Dr. Tex Li-Hsing Chi, AI Chief, FTM Garments Swaziland |
| 2 | Two TMMs in the World (Africa map) |
| 3 | Outline |
| 4–5 | 序曲 (Overture) |
| 6–12 | Q&A 2023 |
| 13–16 | Introduction |
| 17–31 | Projects — medical affairs, capacity building, trauma kits |
| 31 | **Field Medics — Trauma Kits in Action** (TikZ illustration) |
| 32–43 | Public health, oral health, telepathology |
| 44–55 | Somaliland stories, Conclusion, Take-home message |
| 56 | **Finale — 七言絕句** 臺灣醫療使命 |

---

## Contact

Dr. Tex Li-Hsing Chi — `jamal.chi.it@ftmtw.com`  
AI Chief, FTM Garments Swaziland (PTY) Ltd  
Taiwan Medical Mission — Somaliland & Eswatini
