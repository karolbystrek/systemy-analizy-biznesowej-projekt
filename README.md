# Zbiory i wartość eksportu kawy

Projekt z przedmiotu **Systemy Analizy Biznesowej**.  

## Zespół

Karol Bystrek · Patryk Chamera · Mateusz Bielówka · Olaf Grykałowski

## O czym to jest

Hurtownia zielonej kawy chce wiedzieć, **gdzie szukać dodatkowych dostawców**, gdy w dotychczasowych krajach będą słabsze zbiory.

Przygotowujemy dashboard porównujący 51 krajów (lata 2000–2023): zbiory, eksport, wartość za kg, odporność eksportu przy słabych zbiorach oraz tło pogodowe i cenowe. Na końcu wskażemy 3 kraje warte rozważenia.

## Jak to robimy

- **Dane:** FAO (produkcja i handel), Bank Światowy (pogoda, ceny kawy, inflacja), ICO (gatunek kawy).
- **Baza:** SQLite (`data/coffee.db`) — jedno źródło dla raportu i dashboardu.
- **Analiza:** Jupyter + pandas (jakość danych, EDA, KPI).
- **Dashboard:** Python — Streamlit + Plotly (rekomendacja z ćwiczenia 2).
- **Raporty:** Markdown → PDF w `docs/raport-cw2/`.

## Struktura repozytorium

| Folder / plik | Co zawiera |
|---|---|
| `data/` | surowe dane i baza `coffee.db` |
| `sql/` | schemat bazy i widoki KPI |
| `notebooks/` | budowa bazy, jakość danych, EDA |
| `dashboard/` | szkielet aplikacji Streamlit |
| `docs/` | plany, raporty, porównanie narzędzi BI |
| `Opis_projektu_kawa.md` | opis projektu (cel, KPI, hipotezy) |

