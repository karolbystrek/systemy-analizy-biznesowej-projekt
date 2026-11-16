-- KPI definitions shared by the report and the dashboard (K1-K9 in Opis_projektu_kawa.md).
DROP VIEW IF EXISTS v_kpi_country;
DROP VIEW IF EXISTS v_kpi_country_year;

CREATE VIEW v_kpi_country_year AS
WITH base AS (
    SELECT f.*,
           c.country, c.region, c.subregion, c.species,
           y.to_usd_2023,
           CASE c.species WHEN 'arabica' THEN y.arabica_usd_kg WHEN 'robusta' THEN y.robusta_usd_kg END AS reference_usd_kg,
           o.temperature_min_c, o.temperature_max_c, o.precipitation_min_mm, o.precipitation_max_mm,
           LAG(f.production_t) OVER w                       AS production_t_prev,
           LAG(f.export_t) OVER w                           AS export_t_prev,
           LAG(f.export_value_usd) OVER w                   AS export_value_usd_prev,
           LAG(f.export_value_usd * y.to_usd_2023) OVER w   AS export_value_usd_2023_prev
    FROM fact_country_year AS f
    JOIN dim_country AS c USING (iso3)
    JOIN dim_year AS y USING (year)
    LEFT JOIN ref_weather_optimum AS o ON o.species = c.species
    WINDOW w AS (PARTITION BY f.iso3 ORDER BY f.year)
)
SELECT
    iso3, year, country, region, subregion, species,
    production_t, yield_kg_ha, yield_deviation_pct,
    100.0 * (production_t / NULLIF(production_t_prev, 0) - 1)                                AS production_yoy_pct,
    export_t                                                                                  AS k1_export_t,
    export_value_usd                                                                          AS k2_export_value_usd,
    export_value_usd / NULLIF(export_t * 1000, 0)                                             AS k3_usd_per_kg,
    100.0 * (export_t / NULLIF(export_t_prev, 0) - 1)                                         AS k4_export_t_yoy_pct,
    100.0 * (export_value_usd / NULLIF(export_value_usd_prev, 0) - 1)                         AS k5_export_value_yoy_pct,
    export_value_usd * to_usd_2023                                                            AS k2_export_value_usd_2023,
    100.0 * (export_value_usd * to_usd_2023 / NULLIF(export_value_usd_2023_prev, 0) - 1)      AS k5_export_value_usd_2023_yoy_pct,
    export_value_usd * to_usd_2023 / NULLIF(export_t * 1000, 0)                               AS k6_usd_2023_per_kg,
    reference_usd_kg,
    reference_usd_kg * to_usd_2023                                                            AS reference_usd_2023_kg,
    temperature_c, precipitation_mm, temperature_anomaly_c, precipitation_anomaly_pct,
    MAX(temperature_min_c - temperature_c, temperature_c - temperature_max_c, 0)              AS temperature_off_optimum_c,
    MAX(precipitation_min_mm - precipitation_mm, precipitation_mm - precipitation_max_mm, 0)  AS precipitation_off_optimum_mm,
    CASE WHEN species IS NOT NULL THEN
        temperature_c BETWEEN temperature_min_c AND temperature_max_c
        AND precipitation_mm BETWEEN precipitation_min_mm AND precipitation_max_mm
    END                                                                                       AS weather_in_optimum
FROM base;

CREATE VIEW v_kpi_country AS
SELECT
    k.iso3, k.country, k.region, k.subregion, k.species,
    AVG(k.k1_export_t)                                                         AS mean_export_t,
    w.yield_temperature_r                                                      AS k7_yield_temperature_r,
    w.yield_precipitation_r                                                    AS k7_yield_precipitation_r,
    100.0 * AVG(k.weather_in_optimum)                                          AS k8_weather_in_optimum_pct,
    SQRT(AVG(k.temperature_off_optimum_c * k.temperature_off_optimum_c))       AS k9_temperature_off_optimum_c,
    SQRT(AVG(k.precipitation_off_optimum_mm * k.precipitation_off_optimum_mm)) AS k9_precipitation_off_optimum_mm
FROM v_kpi_country_year AS k
LEFT JOIN weather_yield_correlation AS w USING (iso3)
GROUP BY k.iso3;
