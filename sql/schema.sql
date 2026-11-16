-- Rebuilds the whole database; executed by notebooks/02_build_database.ipynb.
PRAGMA foreign_keys = ON;

DROP VIEW IF EXISTS v_kpi_country;
DROP VIEW IF EXISTS v_kpi_country_year;
DROP TABLE IF EXISTS weather_yield_correlation;
DROP TABLE IF EXISTS fact_country_year;
DROP TABLE IF EXISTS dim_country;
DROP TABLE IF EXISTS dim_year;
DROP TABLE IF EXISTS ref_weather_optimum;

CREATE TABLE ref_weather_optimum (
    species              TEXT PRIMARY KEY CHECK (species IN ('arabica', 'robusta')),
    temperature_min_c    REAL NOT NULL,
    temperature_max_c    REAL NOT NULL,
    precipitation_min_mm REAL NOT NULL,
    precipitation_max_mm REAL NOT NULL,
    source               TEXT NOT NULL,
    CHECK (temperature_min_c < temperature_max_c),
    CHECK (precipitation_min_mm < precipitation_max_mm)
);

CREATE TABLE dim_year (
    year           INTEGER PRIMARY KEY CHECK (year BETWEEN 2000 AND 2023),
    cpi_usa        REAL NOT NULL CHECK (cpi_usa > 0),      -- 2010 = 100
    to_usd_2023    REAL NOT NULL CHECK (to_usd_2023 > 0),  -- CPI(2023) / CPI(year)
    arabica_usd_kg REAL NOT NULL CHECK (arabica_usd_kg > 0),
    robusta_usd_kg REAL NOT NULL CHECK (robusta_usd_kg > 0)
);

CREATE TABLE dim_country (
    iso3      TEXT PRIMARY KEY CHECK (length(iso3) = 3),
    country   TEXT NOT NULL UNIQUE,  -- FAO name
    m49       TEXT NOT NULL UNIQUE,
    region    TEXT NOT NULL,
    subregion TEXT NOT NULL,         -- M49 intermediate region, else sub-region
    ico_type  TEXT CHECK (ico_type IN ('A', 'R', 'A/R', 'R/A')),
    species   TEXT REFERENCES ref_weather_optimum (species)
);

CREATE TABLE fact_country_year (
    iso3                      TEXT    NOT NULL REFERENCES dim_country (iso3),
    year                      INTEGER NOT NULL REFERENCES dim_year (year),
    area_ha                   REAL    NOT NULL CHECK (area_ha >= 0),
    production_t              REAL    NOT NULL CHECK (production_t >= 0),
    yield_kg_ha               REAL    NOT NULL CHECK (yield_kg_ha >= 0),
    yield_deviation_pct       REAL    NOT NULL,  -- vs the country's linear trend 2000-2023
    export_t                  REAL    NOT NULL CHECK (export_t >= 0),
    export_value_usd          REAL    NOT NULL CHECK (export_value_usd >= 0),
    temperature_c             REAL    NOT NULL,
    precipitation_mm          REAL    NOT NULL CHECK (precipitation_mm >= 0),
    temperature_anomaly_c     REAL    NOT NULL,  -- vs the country's 1991-2020 mean
    precipitation_anomaly_pct REAL    NOT NULL,
    area_flag                 TEXT    NOT NULL CHECK (area_flag IN ('A', 'E', 'I', 'X')),
    production_flag           TEXT    NOT NULL CHECK (production_flag IN ('A', 'E', 'I', 'X')),
    yield_flag                TEXT    NOT NULL CHECK (yield_flag IN ('A', 'E', 'I', 'X')),
    export_t_flag             TEXT    NOT NULL CHECK (export_t_flag IN ('A', 'E', 'I', 'X')),
    export_value_flag         TEXT    NOT NULL CHECK (export_value_flag IN ('A', 'E', 'I', 'X')),
    PRIMARY KEY (iso3, year)
);

CREATE TABLE weather_yield_correlation (
    iso3                       TEXT    PRIMARY KEY REFERENCES dim_country (iso3),
    yield_temperature_r        REAL    CHECK (yield_temperature_r BETWEEN -1 AND 1),
    yield_precipitation_r      REAL    CHECK (yield_precipitation_r BETWEEN -1 AND 1),
    temperature_paired_years   INTEGER NOT NULL,
    precipitation_paired_years INTEGER NOT NULL
);
