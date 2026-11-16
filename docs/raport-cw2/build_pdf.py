"""Builds raport-cw2.pdf from raport-cw2.md (Markdown -> HTML -> PDF printed by headless Microsoft Edge)."""
from pathlib import Path
import subprocess

import markdown

HERE = Path(__file__).resolve().parent
EDGE = Path(r"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe")
CSS = """
@page { size: A4; margin: 15mm 14mm; }
body { font-family: "Segoe UI", Arial, sans-serif; font-size: 10pt; line-height: 1.4; color: #222; }
h1 { font-size: 19pt; color: #3E2723; margin: 0 0 6pt; }
h2 { font-size: 14pt; color: #4E342E; border-bottom: 1px solid #BCAAA4; padding-bottom: 2pt; margin: 16pt 0 6pt; }
h3 { font-size: 11pt; color: #4E342E; margin: 12pt 0 4pt; }
h2, h3 { break-after: avoid; }
p, li { margin: 3pt 0; }
table { border-collapse: collapse; width: 100%; font-size: 8.3pt; margin: 6pt 0 10pt; }
th, td { border: 1px solid #D7CCC8; padding: 2.5pt 4pt; vertical-align: top; text-align: left; }
th { background: #EFEBE9; }
tr, img { page-break-inside: avoid; }
img { max-width: 100%; display: block; margin: 6pt auto; }
code { font-size: 8.5pt; background: #F5F5F5; padding: 0 2pt; }
.page-break { page-break-after: always; }
"""

body = markdown.markdown((HERE / "raport-cw2.md").read_text(encoding="utf-8"), extensions=["tables", "sane_lists"])
page = HERE / "raport-cw2.html"
page.write_text(f'<!doctype html><html lang="pl"><head><meta charset="utf-8"><style>{CSS}</style></head>'
                f"<body>{body}</body></html>", encoding="utf-8")
pdf = HERE / "raport-cw2.pdf"
pdf.unlink(missing_ok=True)
subprocess.run([str(EDGE), "--headless=new", "--disable-gpu", "--no-pdf-header-footer",
                f"--print-to-pdf={pdf}", page.as_uri()], capture_output=True, timeout=180)
page.unlink()
assert pdf.exists(), "Edge did not produce the PDF"
print(f"{pdf.name}: {pdf.stat().st_size / 1024:.0f} KB")
