#!/bin/bash
# build.sh — one-command build of main.pdf (XeLaTeX x2). Converts every *.svg to svg-inkscape/ with rsvg-convert
# and writes the .pdf_tex wrappers the svg package expects (the method in COMPILE.md), so Inkscape is never called.
set -eu
cd "$(dirname "$0")"
mkdir -p svg-inkscape
for f in *.svg; do
  out="svg-inkscape/${f%.svg}_svg-tex.pdf"
  [ "$out" -nt "$f" ] || rsvg-convert -f pdf -o "$out" "$f"
done
python3 - <<'PY'
import os, re, xml.etree.ElementTree as ET
def dims(p):
    try:
        r = ET.parse(p).getroot(); vb = r.get('viewBox')
        if vb and len(vb.split()) == 4: return float(vb.split()[2]), float(vb.split()[3])
        u = lambda s: float(re.sub(r'[a-z%]', '', s)) if s else 100.0
        return u(r.get('width', '100')), u(r.get('height', '100'))
    except Exception: return 100.0, 100.0
T = r"""\begingroup%
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
for f in sorted(os.listdir('.')):
    if not f.endswith('.svg'): continue
    b = f[:-4]; pdf = 'svg-inkscape/' + b + '_svg-tex.pdf'
    if not os.path.exists(pdf): continue
    w, h = dims(f)
    open('svg-inkscape/' + b + '_svg-tex.pdf_tex', 'w').write(T.format(w=w, ratio=h / w if w > 0 else 1.0, pdf=pdf))
PY
xelatex -interaction=nonstopmode -halt-on-error main.tex > /dev/null || { tail -30 main.log; exit 1; }
xelatex -interaction=nonstopmode -halt-on-error main.tex > /dev/null || { tail -30 main.log; exit 1; }
pages=$(pdfinfo main.pdf 2>/dev/null | awk '/^Pages/{print $2}')
echo "main.pdf: ${pages:-?} pages"
grep -c 'Overfull' main.log | sed 's/^/overfull boxes: /'
