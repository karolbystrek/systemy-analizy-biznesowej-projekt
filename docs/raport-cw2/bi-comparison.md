# Porównanie systemów BI i rekomendacja

## Kontekst i wymagania

- **Klient:** właściciel małej hurtowni zielonej kawy bez działu IT. Raport tylko przegląda i potrzebuje do niego linku.
- **Dane:** 51 krajów × 24 lata w bazie SQLite (192 KB). KPI K1–K10 są zdefiniowane w widokach SQL, a przygotowanie danych i EDA robimy w Pythonie i wersjonujemy w Git.
- **Wymóg projektu:** cały projekt, łącznie z dashboardem, powstaje w Pythonie (zgoda prowadzącego).
- **Porównywane systemy:** trzy klasyczne narzędzia BI (Power BI, Tableau, Looker Studio) oraz Python ze Streamlit i Plotly.

## Kryteria i wagi

| Kryterium | Waga | Dlaczego taka waga |
|---|---|---|
| Integracja z danymi i stosem projektu (SQLite, KPI w SQL, Python, Git) | 25% | baza SQLite jest jedynym źródłem danych, a projekt ma powstać w Pythonie |
| Funkcjonalność analityczna (r/r, opóźnienie, mediany, ceny stałe, rozdział zmiany wartości) | 20% | K4–K10 i M1 wymagają obliczeń między latami |
| Koszt i dostępność | 15% | mała firma; zespół studencki |
| Publikacja i współpraca | 15% | klient musi otworzyć raport z linku |
| Wizualizacja i interakcje | 15% | mapa, filtry, przejście z rankingu do kraju |
| Łatwość obsługi | 10% | klient tylko przegląda; tworzy zespół |

## Ocena (skala 1–5)

| Kryterium (waga) | Power BI | Tableau | Looker Studio | Python (Streamlit + Plotly) |
|---|---|---|---|---|
| Integracja (25%) | **2** – SQLite tylko przez sterownik ODBC; logikę KPI trzeba powielić w DAX | **2** – SQLite przez ODBC tylko w płatnym Desktop; Tableau Public go nie obsługuje | **1** – brak konektora SQLite; potrzebny eksport do CSV lub Google Sheets | **5** – czyta SQLite bezpośrednio i korzysta z tych samych widoków KPI co raport |
| Funkcjonalność (20%) | **5** – DAX i funkcje czasu dobrze obsługują r/r i ceny stałe | **4** – obliczenia tabelaryczne i LOD; mediany i opóźnienia wymagają wprawy | **2** – proste pola obliczeniowe; r/r z opóźnieniem i mediany są trudne | **5** – dowolne obliczenia w SQL i pandas |
| Koszt (15%) | **3** – Desktop darmowy, ale udostępnianie wymaga Pro (14 USD/mies.) dla autora i każdego odbiorcy | **2** – Creator 75 USD/mies.; darmowa edycja Desktop Public nie jest do użytku komercyjnego | **5** – darmowy | **5** – oprogramowanie otwartoźródłowe; darmowy hosting Community Cloud |
| Publikacja (15%) | **3** – udostępnianie w Power BI Service wymaga licencji Pro po obu stronach | **4** – łatwy link (Public lub Cloud), ale Public zawsze publikuje dane publicznie | **5** – link w przeglądarce, współpraca jak w Google Docs | **4** – publiczny link; jedna aplikacja prywatna; aplikacja usypia po 12 h bez ruchu |
| Wizualizacja (15%) | **4** – bogate wizualizacje, mapy, przejście do szczegółów | **5** – najlepsza jakość wizualizacji i opowiadania historii | **3** – podstawowe wykresy i mapy; ograniczone przejścia do szczegółów | **4** – interaktywne wykresy Plotly i mapy; układ trzeba zbudować w kodzie |
| Łatwość obsługi (10%) | **4** – tworzenie przez przeciąganie, przeglądanie intuicyjne | **3** – dłuższa nauka | **4** – prosty edytor w przeglądarce | **3** – przeglądanie proste, ale tworzenie i zmiany wymagają programowania |
| **Wynik ważony** | **3,40** | **3,25** | **3,00** | **4,50** |

**Wrażliwość na wagi:**

| Wariant wag | Power BI | Tableau | Looker Studio | Python |
|---|---|---|---|---|
| docelowe (25/20/15/15/15/10) | 3,40 | 3,25 | 3,00 | **4,50** |
| z planu (20/20/15/15/15/15) | 3,50 | 3,30 | 3,15 | **4,40** |
| równe | 3,50 | 3,33 | 3,33 | **4,33** |
| koszt i publikacja ×2 (15/15/25/25/10/10) | 3,35 | 3,20 | 3,65 | **4,45** |

## Noty opisowe

**Power BI**
- (+) najmocniejsze modelowanie danych (DAX, relacje, funkcje czasu),
- (+) standard w firmach, bogaty zestaw wizualizacji,
- (−) Desktop działa tylko na Windows; SQLite tylko przez sterownik ODBC,
- (−) każdy odbiorca udostępnionego raportu potrzebuje licencji Pro, a logikę KPI trzeba powielić w DAX.

**Tableau**
- (+) najlepsza jakość wizualizacji i opowiadania historii danymi,
- (+) Tableau Public pozwala darmowo opublikować raport z otwartymi danymi,
- (−) najdroższy (Creator 75 USD/mies.),
- (−) Tableau Public nie łączy się z SQLite, a darmowa edycja Desktop Public nie jest do użytku komercyjnego.

**Looker Studio**
- (+) darmowy, działa w przeglądarce, łatwo udostępnić link,
- (+) najprostszy dla początkujących,
- (−) brak konektora SQLite – potrzebna kopia danych w Google Sheets lub BigQuery,
- (−) słabe modelowanie; K4–K10 i M1 trzeba by policzyć poza narzędziem.

**Python (Streamlit + Plotly)**
- (+) jedno źródło prawdy: dashboard czyta te same widoki SQL co raport,
- (+) pełna kontrola obliczeń; kod wersjonowany w Git razem z danymi,
- (+) zerowy koszt licencji i hostingu dla publicznych danych,
- (−) każdą zmianę układu trzeba zaprogramować, a klient nie zbuduje własnego widoku,
- (−) darmowy hosting ma ograniczenia: jedna aplikacja prywatna, usypianie po 12 h, limity zasobów.

## System Recommendation Note

**Projekt:** Zbiory i wartość eksportu kawy. **Cel:** wybór narzędzia do dashboardu dla właściciela hurtowni zielonej kawy. **Porównane systemy:** Power BI, Tableau, Looker Studio, Python (Streamlit + Plotly). **Data:** 16.11.2026. **Autor:** Patryk Chamera.

**Kontekst.** Hurtownia szuka dodatkowych dostawców kawy. Potrzebuje dashboardu z rankingiem 51 krajów, wskaźnikami odporności eksportu i wartością za kilogram w cenach bieżących i stałych. Dane i definicje KPI są już w bazie SQLite i w Pythonie, a projekt ma powstać w całości w Pythonie.

**Porównanie.** Cztery narzędzia oceniono w skali 1–5 według sześciu wspólnych kryteriów. Najwyższą wagę ma integracja z danymi i stosem projektu (25%), a następnie funkcjonalność analityczna (20%).

**Wynik.** Python (Streamlit + Plotly) uzyskał 4,50 pkt, Power BI 3,40, Tableau 3,25, a Looker Studio 3,00. Python wygrywa we wszystkich czterech sprawdzonych wariantach wag (4,33–4,50).

**Kluczowe obserwacje.**
- Klasyczne systemy BI wymagają kopii danych albo sterownika ODBC oraz powielenia logiki KPI. To grozi rozbieżnością liczb między raportem a dashboardem.
- Power BI ma najlepsze modelowanie, ale udostępnienie raportu jednemu klientowi kosztuje 14 USD/mies. za każdą osobę.
- Tableau daje najładniejsze wizualizacje, ale jest najdroższe.
- Looker Studio jest darmowe, ale za słabe w obliczeniach między latami.

**Rekomendacja.** Rekomendujemy dashboard w Pythonie: **Streamlit** jako interfejs i **Plotly** do wykresów i mapy, z bazą `data/coffee.db` jako jedynym źródłem danych. Publikacja na Streamlit Community Cloud jako aplikacja publiczna – dane są otwarte (FAO, Bank Światowy, ICO), więc publiczny link nie stanowi problemu. Wybieramy Streamlit, a nie Plotly Dash, bo do trzech stron z filtrami wystarcza prostszy model programowania.

**Ryzyka i ograniczenia.**
- Każda zmiana wymaga programisty – ograniczamy to stałym układem trzech stron i filtrami, które pokrywają pytania klienta.
- Aplikacja usypia po 12 h bez ruchu i trzeba ją obudzić jednym kliknięciem – akceptowalne przy sporadycznym przeglądaniu; przed prezentacją otwieramy ją wcześniej.
- Darmowy hosting ma limity zasobów (do 2,7 GB RAM) – nasza baza ma 192 KB, więc zapas jest duży.
- Gdyby klient chciał samodzielnie budować raporty, naturalną alternatywą jest Power BI (drugie miejsce).

**Dalsze kroki.**
1. Szkielet `dashboard/app.py` w Streamlit jako wireframe (krok 7).
2. Dashboard z trzema stronami i filtrami (etap 4).
3. Publikacja na Streamlit Community Cloud i test linku przez osobę spoza zespołu.

**Źródła (sprawdzone 16.11.2026):**
- [Power BI – cennik](https://www.microsoft.com/en-us/microsoft-fabric/features/power-bi/pricing),
- [Tableau – cennik](https://www.tableau.com/pricing/individual), [porównanie edycji Desktop](https://help.tableau.com/current/pro/desktop/en-us/desktop_comparison.htm),
- [Looker Studio – konektory](https://cloud.google.com/looker/docs/studio/available-connectors),
- [Streamlit Community Cloud – limity](https://docs.streamlit.io/deploy/streamlit-community-cloud/manage-your-app).
