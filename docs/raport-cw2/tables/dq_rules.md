| ID   | reguła                                                        | priorytet   | egzekwowanie                             | naruszenia [wiersze]   |
|:-----|:--------------------------------------------------------------|:------------|:-----------------------------------------|:-----------------------|
| R1   | (iso3, year) unikalne i niepuste                              | krytyczny   | schemat: PRIMARY KEY                     | 0                      |
| R2   | iso3 i year z faktów istnieją w wymiarach                     | krytyczny   | schemat: FOREIGN KEY                     | 0                      |
| R3   | zbiory i eksport w t, wartość w 1000 USD                      | krytyczny   | assert na kolumnie Unit przed ładowaniem | –                      |
| R4   | zbiory, eksport i wartość ≥ 0                                 | krytyczny   | schemat: CHECK                           | 0                      |
| R5   | eksport (wolumen i wartość) we wszystkich 24 latach           | wysoki      | notebook 02: wykluczenie kraju           | 0                      |
| R6   | każdy rok ma CPI i obie ceny                                  | wysoki      | schemat: NOT NULL                        | 0                      |
| R7   | K3 tylko przy wolumenie > 0; K4 i K5 tylko przy podstawie > 0 | wysoki      | widok: NULLIF                            | 0                      |
| R8   | zmiana r/r zbiorów lub eksportu powyżej ±50%                  | średni      | zapytanie kontrolne → flaga              | 309                    |
| R9   | eksport większy niż zbiory                                    | średni      | zapytanie kontrolne → flaga              | 152                    |
| R10  | K3 poza 0,5–2 × cena referencyjna gatunku (próg wstępny)      | średni      | zapytanie kontrolne → przegląd           | 150                    |
| R11  | plon ≈ zbiory / powierzchnia (±5%)                            | niski       | zapytanie kontrolne → flaga              | 1                      |
