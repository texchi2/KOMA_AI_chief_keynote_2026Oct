# KOMA AI Chief Keynote — 6 May 2026

**Holistic Healthcare from Taiwan Medical Mission in the Republic of Somaliland**  
臺灣城市偏鄉 vs 非洲的距離

> Keynote speaker: **Dr. Tex Li-Hsing Chi**, D.D.S., Ph.D.  
> AI Chief — FTM Garments Swaziland (PTY) Ltd  
> Oral and Maxillofacial Surgeon · Translational Medicine

---

## Overview

A 56-slide Beamer (LaTeX) presentation delivered on 6 May 2026.  
It traces the work of the Taiwan Medical Mission (TMM) across two postings —
Somaliland (2022–) and Eswatini (2008–) — through four pillars:

| Pillar | Content |
|---|---|
| Medical affairs | Trauma ward, OT, OBS/ED, home visits |
| Capacity building | On-the-job training, equipment, trauma kits for armed forces |
| Public health | Pap smear, blood donation, oral health, HBV/HCV, osteoporosis, parasites |
| Telemedicine | Telepathology (WSI), RadiPush, TOM AI osteoporosis diagnosis |

Closes with a **七言絕句** finale 《臺灣醫療使命》 celebrating Taiwan–Eswatini partnership.

---

## Slide Summary

| Slides | Section |
|---|---|
| 1 | Title — AI Chief, FTM Garments Swaziland |
| 2 | Two TMMs in the World (Africa map) |
| 3 | Outline |
| 4–5 | 序曲 Overture |
| 6–12 | Q&A 2023 |
| 13–16 | Introduction — TMM team & missions |
| 17–31 | Projects (medical affairs, capacity building) |
| 31 | Field Medics: Trauma Kits in Action (TikZ illustration) |
| 32–43 | Public health & research |
| 44–55 | Somaliland patient stories, conclusion |
| 56 | Finale — 七言絕句 《臺灣醫療使命》 |

---

## Build

See **[COMPILE.md](COMPILE.md)** for full instructions.  
Quick start (requires XeLaTeX + Songti TC font):

```bash
xelatex -interaction=nonstopmode main.tex
xelatex -interaction=nonstopmode main.tex   # second pass for TOC
```

**First time only** — pre-convert SVGs (if Inkscape unavailable):

```bash
mkdir -p svg-inkscape
for f in *.svg; do
    rsvg-convert -f pdf -o "svg-inkscape/${f%.svg}_svg-tex.pdf" "$f"
done
# then run the pdf_tex generator in COMPILE.md
```

---

## Repository Structure

```
├── main.tex          # Single-source Beamer presentation (XeLaTeX)
├── README.md         # This file
├── COMPILE.md        # Detailed build guide (SVG setup, fonts, latexmk)
├── *.svg             # Vector logos and custom illustrations
├── *.jpg / *.png     # Photo assets from TMM missions
└── main.pdf          # Output — gitignored, rebuild locally
```

---

## Key Custom Elements

- **TikZ trauma kit illustration** (slide 31) — African war field scene with
  medic, wounded soldier, large yellow backpack marked with Red Crescent ☾
- **TikZ-drawn Red Crescent** on backpack and armband (respectful to
  Somaliland's Muslim culture — not Red Cross)
- **七言絕句** poem (slide 56) composed for this keynote, rhyme scheme 陽韻:

  > 寶島醫隊越重洋，  
  > 索蘭史瓦共翱翔。  
  > 公衛教學攜手志，  
  > 臺史共燃智慧光。

---

## Contact

Dr. Tex Li-Hsing Chi · `jamal.chi.it@ftmtw.com`  
AI Chief · FTM Garments Swaziland (PTY) Ltd  
Taiwan Medical Mission — Somaliland & Eswatini
