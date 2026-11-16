from contextlib import closing
from pathlib import Path
import sqlite3

import pandas as pd
import streamlit as st

DB = Path(__file__).resolve().parents[1] / "data" / "coffee.db"
REGION_PL = {"Americas": "Ameryki", "Africa": "Afryka", "Asia": "Azja", "Oceania": "Oceania"}
SPECIES_PL = {"arabica": "arabika", "robusta": "robusta"}
COLORS = {
    "wolumen i wartość": "#6D4C41",
    "arabika": "#1565C0",
    "robusta": "#EF6C00",
    "wzrost": "#2E7D32",
    "spadek": "#C62828",
}

st.set_page_config(page_title="Kawa – nowi dostawcy", page_icon="☕", layout="wide")


@st.cache_data
def query(sql):
    with closing(sqlite3.connect(f"file:{DB.as_posix()}?mode=ro", uri=True)) as con:
        return pd.read_sql(sql, con)


def kpi_cards(cards):
    for column, (label, note) in zip(st.columns(len(cards)), cards):
        column.metric(label, "—", help=note)


def placeholder(title, description, height=300):
    with st.container(border=True, height=height):
        st.markdown(f"**{title}**")
        st.caption(description)


countries = query("SELECT iso3, country, region, species FROM dim_country ORDER BY country")
years = query("SELECT year FROM dim_year")["year"]

with st.sidebar:
    st.header("Filtry")
    year = st.slider("Rok", int(years.min()), int(years.max()), int(years.max()))
    st.multiselect("Region", [REGION_PL[r] for r in sorted(countries["region"].unique())], placeholder="wszystkie")
    st.multiselect("Gatunek", ["arabika", "robusta"], placeholder="wszystkie")
    country = st.selectbox("Kraj (strona 3)", countries["country"], index=int(countries["country"].eq("Brazil").idxmax()))
    prices = st.radio("Ceny", ["bieżące", "stałe z 2023 r."], horizontal=True)
    st.divider()
    st.caption("Kolorystyka wykresów")
    st.markdown(" ".join(f'<span style="background:{color};color:white;padding:2px 6px;border-radius:4px;'
                         f'font-size:0.8em">{name}</span>' for name, color in COLORS.items()),
                unsafe_allow_html=True)
    st.caption(f"Źródła: FAOSTAT, Bank Światowy, ICO, USDA FAS. Baza: {DB.name}")


def market_overview():
    st.title("Przegląd rynku zielonej kawy")
    st.caption(f"Pytanie klienta 1: gdzie szukać dodatkowych dostawców? Rok {year}, ceny {prices}. "
               "Wireframe – wykresy powstaną w etapie 4.")
    kpi_cards([("K1 Wolumen", "wolumen eksportu, t"), ("K2 Wartość", "wartość eksportu, USD"),
               ("K3 USD/kg", "wartość za kg, ceny bieżące"), ("K4 Wolumen r/r", "zmiana wolumenu, %"),
               ("K5 Wartość r/r", "zmiana wartości, %"), ("K6 USD/kg realnie", "wartość za kg, USD z 2023 r.")])
    left, right = st.columns([2, 1])
    with left:
        placeholder("Mapa bąbelkowa eksportu",
                    "Wielkość bąbla = K1 w wybranym roku, kolor = gatunek dominujący. "
                    "Najechanie pokazuje K1–K6 kraju, kliknięcie ustawia filtr „Kraj”.", height=360)
    with right:
        placeholder("Ranking 10 największych eksporterów",
                    "Słupki poziome: średni K1 i udział w eksporcie. Kliknięcie kraju → strona „Wartość za kg”. "
                    "Bez USA (reeksporter).", height=360)
    placeholder("Trend 2000–2023",
                "Linie: łączny K1 (lewa oś) i K2 w cenach bieżących lub stałych (prawa oś), "
                "pionowa linia = wybrany rok.", height=240)


def supply_resilience():
    st.title("Odporność dostaw")
    st.caption("Pytanie klienta 2: które kraje utrzymywały eksport mimo słabszych zbiorów (spadek zbiorów o ponad 10% r/r)?")
    kpi_cards([("K10 Odporność", "mediana K4 w latach słabszych zbiorów, %"), ("Słabsze lata", "liczba lat ze spadkiem zbiorów > 10%"),
               ("K8 Pogoda w normie", "% lat w normie 1991–2020"), ("K9 Odchylenie", "od normy 1991–2020, °C i %"),
               ("K7 Pogoda–plon", "korelacja Pearsona r")])
    st.radio("Zmiana eksportu", ["w tym samym roku", "rok później"], horizontal=True, key="lag")
    left, right = st.columns([1, 1])
    with left:
        placeholder("Zbiory a eksport",
                    "Wykres punktowy: zmiana zbiorów r/r (oś X) a K4 (oś Y), punkt = kraj-rok; "
                    "zielone / czerwone ćwiartki; wybrany kraj wyróżniony.", height=480)
    with right:
        placeholder("Ranking dostawców",
                    "Tabela: kraj, gatunek, średni K1, K10, liczba słabszych lat (min. 3), K8, K9, K7. "
                    "Trzy rekomendowane kraje wyróżnione. Bez USA i krajów z eksportem < 1 tys. t/rok.", height=480)


def unit_value():
    species = countries.loc[countries["country"].eq(country), "species"].iloc[0]
    st.title(f"Wartość za kg – {country}")
    st.caption(f"Pytanie klienta 3: jak zmieniała się wartość eksportu za kilogram? "
               f"Gatunek dominujący: {SPECIES_PL.get(species, 'brak danych')}, ceny {prices}.")
    kpi_cards([("K3 USD/kg", "wartość za kg, ceny bieżące"), ("K6 USD/kg realnie", "wartość za kg, USD z 2023 r."),
               ("Cena światowa", "cena gatunku, Pink Sheet, USD/kg"), ("K3 / cena", "K3 jako % ceny światowej"),
               ("K5 Wartość r/r", "zmiana wartości, %")])
    placeholder("K3 kraju na tle ceny światowej",
                "Linie 2000–2023: K3 kraju (brąz) i cena arabiki lub robusty (kolor gatunku, przerywana); "
                "lata słabszych zbiorów zacienione.", height=320)
    placeholder("Skąd zmiana wartości eksportu (M1)",
                "Słupki skumulowane dla każdego roku: efekt ilości i efekt ceny (zielony = wzrost, czerwony = spadek), "
                "punkt = zmiana K2.", height=280)


st.navigation([
    st.Page(market_overview, title="Przegląd rynku", icon="🌍", url_path="przeglad", default=True),
    st.Page(supply_resilience, title="Odporność dostaw", icon="🛡️", url_path="odpornosc"),
    st.Page(unit_value, title="Wartość za kg", icon="💲", url_path="wartosc"),
]).run()
