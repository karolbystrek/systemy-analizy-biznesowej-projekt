# Zbiory i wartość eksportu kawy 

_Systemy Analizy Biznesowej   Ćwiczenie 1_ 

## **1 Nazwa projektu i obszar** 

Nazwa: Zbiory i wartość eksportu kawy. 

Obszar: analiza produkcji i eksportu zielonej kawy z uwzględnieniem pogody i cen światowych. 

## **2 Cel SMART i odbiorca** 

Odbiorcą jest właściciel hurtowni zielonej kawy, która zaopatruje polskie palarnie. Kupuje głównie z dwóch krajów i chce ustalić, gdzie szukać dodatkowych dostawców na wypadek słabszych zbiorów. 

W ciągu 4 tygodni przygotujemy dashboard porównujący zbiory, eksport i wartość eksportu za kilogram w 51 krajach w latach 2000-2023. Wskażemy 3 kraje, w których warto rozpocząć poszukiwania dostawców, i uzasadnimy wybór na podstawie wielkości eksportu oraz tego, jak zmieniał się w latach słabszych zbiorów. 

## **3 Źródła danych** 

Produkcja kawy - FAOSTAT. Roczne dane o zbiorach, powierzchni zbiorów i plonach zielonej kawy. Pliki CSV. 

https://www.fao.org/faostat/en/#data/QCL 

Eksport kawy - FAOSTAT. Roczna ilość eksportowanej zielonej kawy w tonach i jej wartość w tysiącach USD. Pliki CSV. 

https://www.fao.org/faostat/en/#data/TCL 

Pogoda - World Bank CCKP. Średnia roczna temperatura i suma opadów w każdym kraju, na podstawie danych ERA5. Format JSON. 

https://climateknowledgeportal.worldbank.org/download-data 

Ceny kawy - World Bank Pink Sheet. Roczne ceny światowe arabiki i robusty w USD za kilogram. Plik Excel. 

https://www.worldbank.org/en/research/commodity-markets 

Inflacja - World Bank WDI. Roczny indeks cen konsumpcyjnych w USA (CPI, wskaźnik FP.CPI.TOTL) do przeliczenia USD na ceny stałe z 2023 r. Format JSON (API). 

https://data.worldbank.org/indicator/FP.CPI.TOTL?locations=US 

Gatunek kawy i optimum pogodowe - tabela pomocnicza. Dominujący w kraju gatunek (arabika lub robusta) według klasyfikacji ICO oraz przedziały optymalnej temperatury i opadów dla każdego gatunku według literatury agronomicznej (np. DaMatta i Ramalho, 2006). 

https://ico.org 

Licencje: CC BY 4.0 z warunkami FAO i Banku Światowego. Przy danych pogodowych podajemy także źródło ERA5, Copernicus i ECMWF. Warunki wykorzystania: 

https://www.fao.org/contact-us/terms/db-terms-of-use/en/ 

https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets 

Zakres projektu: lata 2000-2023 i 51 krajów z pełnymi danymi eksportowymi, czyli 1224 wiersze krajrok. Uwzględniamy tylko eksport. 

## **4 KPI z definicjami i jednostkami** 

|**KPI**|**Definicja**|**Jednostka**|
|---|---|---|
|K1 Wolumen eksportu|Ilość zielonej kawy wyeksportowanej przez kraj w danym roku.|t|
|K2 Wartość eksportu|Łączna wartość eksportu zielonej kawy; przeliczenie z tysięcy USD.|USD|
|K3 Wartość za kilogram|Wartość eksportu w USD / (wolumen w tonach × 1000). Przy<br>zerowym wolumenie brak wyniku.|USD/kg|
|K4 Zmiana wolumenu|100 × (wolumen bieżący / wolumen poprzedni − 1).|% r/r|
|K5 Zmiana wartości|100 × (wartość bieżąca / wartość poprzednia − 1).|% r/r|
|K6 Wartość za kilogram w cenach stałych|K3 przeliczone na dolary z 2023 r.: K3 × CPI USA (2023) / CPI USA (rok).|USD z 2023 r./kg|
|K7 Korelacja pogody z plonem|Współczynnik korelacji Pearsona między temperaturą (osobno: opadami) a plonem kraju w latach 2000-2023, po usunięciu trendów liniowych.|r (od −1 do 1)|
|K8 Zgodność pogody z optimum|Odsetek lat, w których średnia temperatura i suma opadów mieszczą się w przedziale optymalnym dla gatunku dominującego w kraju.|% lat|
|K9 Odchylenie pogody od optimum|Odchylenie standardowe liczone względem przedziału optymalnego zamiast średniej: √(średnia d²), gdzie d to odległość wartości rocznej od przedziału (0 wewnątrz). Osobno dla temperatury i opadów.|°C; mm|



Zmiany r/r liczymy od 2001 r.; zerowa podstawa oznacza brak wyniku. Rozdział zmiany wartości eksportu na efekty ilości i wartości za kg wykonamy metodą symetryczną, bez podwójnego liczenia. 

Wartości w USD (K2, K3 i ceny arabiki i robusty) pokazujemy w cenach bieżących i stałych z 2023 r., przeliczonych tym samym indeksem CPI. K7-K9 liczymy dla każdego kraju z 24 lat; przedziały optymalne ustalamy osobno dla arabiki i robusty. 

## **5 Hipotezy i pytania analityczne** 

H1. Spadkom zbiorów towarzyszy przeciętnie niższa zmiana wolumenu eksportu niż w latach bez spadku zbiorów. Porównamy ten sam rok i opóźnienie roczne. 

H2. W co najmniej połowie lat ze spadkiem wolumenu eksportu wzrost wartości za kilogram rekompensuje mniejszą ilość, dzięki czemu wartość eksportu w cenach stałych nie maleje. 

H3. Plon względem trendu jest przeciętnie niższy w latach z pogodą poza przedziałem optymalnym niż w latach z pogodą w optimum. 

1. Czy zmiany wartości eksportu wynikają głównie z ilości sprzedanej kawy czy wartości za kilogram? (K1-K5) 

2. Czy spadek zbiorów ogranicza eksport w tym samym czy dopiero następnym roku? (zbiory, K1, K4) 

3. Które kraje utrzymują wolumen eksportu mimo słabszych zbiorów? (zbiory, K1, K4) 

4. Czy nietypowej pogodzie towarzyszą słabsze plony, a następnie mniejszy eksport? (pogoda, plony, K1, K4, K7-K9) 

5. Czy wartość eksportowa za kilogram podąża za cenami światowymi arabiki i robusty? (K3, K6 i ceny referencyjne) 

6. Jaka część zmian wartości za kilogram w latach 2000-2023 wynika z inflacji, a jaka z realnych zmian cen? (K3, K6) 

## **6 Role w zespole** 

|**Osoba**|**Proponowana rola i zadania**|
|---|---|
|Karol Bystrek|Lider i dokumentalista: organizacja, terminy, kontakt z prowadzącym, opis projektu.|
|Mateusz Bielówka|Analityk: przygotowanie, łączenie i analiza danych.|
|Patryk Chamera|Projektant wizualizacji: model w Power BI i dashboard.|
|Olaf Grykałowski|Specjalista ds. biznesu: KPI, interpretacja i wnioski.|



## **7 Ryzyka i plan ograniczania** 

|**Ryzyko**|**Działanie**|
|---|---|
|Braki, szacunki i różne jednostki|Wybrać kraje z kompletnymi danymi, zachować flagi jakości i<br>ujednolicić tony oraz USD.|
|Różne odmiany i jakość kawy|USD/kg traktować jako średnią wartość eksportową, nie cenę kontraktu.<br>Arabikę i robustę porównywać osobno jako punkty odniesienia.|
|Pozorne zależności i uproszczenia|Uwzględnić trendy i opóźnienie roczne. Nie przypisywać pogodzie<br>przyczynowości; zapasy i sezony zbiorów mogą zmieniać wyniki.|
|Pogoda uśredniona dla całego kraju, a nie dla regionów upraw|Optimum traktować orientacyjnie i porównywać lata w obrębie kraju.<br>Jeśli średnie krajowe rzadko mieszczą się w optimum, liczyć odchylenie od normy kraju z lat 1991-2020.|



## **8 Mapa projektu** 

Najpierw pobierzemy dane o produkcji, eksporcie, pogodzie, cenach i inflacji. Następnie je oczyścimy, połączymy według kraju i roku (ceny i inflację według roku) i zapiszemy w bazie SQLite jako model gwiazdy. Na tej podstawie przygotujemy dashboard i wnioski dla właściciela hurtowni. 

Narzędzia: Python w całym procesie – pandas i Jupyter do przygotowania danych, SQLite jako baza danych, matplotlib do wykresów w raportach, Streamlit i Plotly do dashboardu. Git do wersjonowania. 

## **9 Trzy pytania od klienta** 

1. W których trzech krajach warto zacząć szukać dodatkowych dostawców? 

2. Które kraje utrzymywały eksport mimo słabszych zbiorów? 

3. Jak zmieniała się w tych latach wartość eksportu za kilogram? 

Wartość eksportu kraju nie oznacza dochodu ani zysku plantatorów. 

