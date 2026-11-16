-- KPI definitions shared by the report and the dashboard (K1-K10, see docs/raport-cw2/tables/kpi.md).
DROP VIEW IF EXISTS v_kpi_country;
DROP VIEW IF EXISTS v_kpi_country_year;

CREATE VIEW v_kpi_country_year AS
WITH base AS (
    SELECT f.*,
           c.country, c.region, c.subregion, c.species, c.temperature_norm_sd_c, c.precipitation_norm_sd_pct,
           y.to_usd_2023,
           CASE c.species WHEN 'arabica' THEN y.arabica_usd_kg WHEN 'robusta' THEN y.robusta_usd_kg END AS reference_usd_kg,
           o.temperature_min_c, o.temperature_max_c, o.precipitation_min_mm, o.precipitation_max_mm,
           f.export_value_usd / NULLIF(f.export_t * 1000, 0)  AS usd_per_kg,
           LAG(f.production_t) OVER w                         AS production_t_prev,
           LAG(f.export_t) OVER w                             AS export_t_prev,
           LAG(f.export_value_usd) OVER w                     AS export_value_usd_prev,
           LAG(f.export_value_usd * y.to_usd_2023) OVER w     AS export_value_usd_2023_prev,
           LAG(f.export_value_usd / NULLIF(f.export_t * 1000, 0)) OVER w AS usd_per_kg_prev
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
    usd_per_kg                                                                                AS k3_usd_per_kg,
    100.0 * (export_t / NULLIF(export_t_prev, 0) - 1)                                         AS k4_export_t_yoy_pct,
    100.0 * (export_value_usd / NULLIF(export_value_usd_prev, 0) - 1)                         AS k5_export_value_yoy_pct,
    export_value_usd * to_usd_2023                                                            AS k2_export_value_usd_2023,
    100.0 * (export_value_usd * to_usd_2023 / NULLIF(export_value_usd_2023_prev, 0) - 1)      AS k5_export_value_usd_2023_yoy_pct,
    usd_per_kg * to_usd_2023                                                                  AS k6_usd_2023_per_kg,
    -- Symmetric split of the value change: the two effects add up exactly to K2 - K2(previous year).
    (export_t - export_t_prev) * 1000 * (usd_per_kg + usd_per_kg_prev) / 2                    AS value_change_volume_effect_usd,
    (usd_per_kg - usd_per_kg_prev) * (export_t + export_t_prev) * 1000 / 2                    AS value_change_price_effect_usd,
    reference_usd_kg,
    reference_usd_kg * to_usd_2023                                                            AS reference_usd_2023_kg,
    temperature_c, precipitation_mm, temperature_anomaly_c, precipitation_anomaly_pct,
    ABS(temperature_anomaly_c) <= temperature_norm_sd_c
        AND ABS(precipitation_anomaly_pct) <= precipitation_norm_sd_pct                       AS weather_in_norm,
    -- Literature optimum: kept for the EDA check that rejected it for K8/K9 (country means miss coffee altitudes).
    MAX(temperature_min_c - temperature_c, temperature_c - temperature_max_c, 0)              AS temperature_off_optimum_c,
    MAX(precipitation_min_mm - precipitation_mm, precipitation_mm - precipitation_max_mm, 0)  AS precipitation_off_optimum_mm,
    CASE WHEN species IS NOT NULL THEN
        temperature_c BETWEEN temperature_min_c AND temperature_max_c
        AND precipitation_mm BETWEEN precipitation_min_mm AND precipitation_max_mm
    END                                                                                       AS weather_in_optimum
FROM base;

CREATE VIEW v_kpi_country AS
WITH weak_harvest AS (
    SELECT iso3, k4_export_t_yoy_pct AS k4,
           ROW_NUMBER() OVER (PARTITION BY iso3 ORDER BY k4_export_t_yoy_pct) AS position,
           COUNT(*) OVER (PARTITION BY iso3) AS years
    FROM v_kpi_country_year
    WHERE production_yoy_pct < -10 AND k4_export_t_yoy_pct IS NOT NULL
),
resilience AS (
    -- SQLite has no MEDIAN: average the middle row (odd count) or the two middle rows (even count).
    SELECT iso3, AVG(k4) AS k10_export_resilience_pct, MAX(years) AS weak_harvest_years
    FROM weak_harvest
    WHERE position IN ((years + 1) / 2, (years + 2) / 2)
    GROUP BY iso3
)
SELECT
    k.iso3, k.country, k.region, k.subregion, k.species,
    AVG(k.k1_export_t)                                                         AS mean_export_t,
    w.yield_temperature_r                                                      AS k7_yield_temperature_r,
    w.yield_precipitation_r                                                    AS k7_yield_precipitation_r,
    100.0 * AVG(k.weather_in_norm)                                             AS k8_weather_in_norm_pct,
    SQRT(AVG(k.temperature_anomaly_c * k.temperature_anomaly_c))               AS k9_temperature_anomaly_rms_c,
    SQRT(AVG(k.precipitation_anomaly_pct * k.precipitation_anomaly_pct))       AS k9_precipitation_anomaly_rms_pct,
    r.k10_export_resilience_pct,
    COALESCE(r.weak_harvest_years, 0)                                          AS weak_harvest_years
FROM v_kpi_country_year AS k
LEFT JOIN weather_yield_correlation AS w USING (iso3)
LEFT JOIN resilience AS r USING (iso3)
GROUP BY k.iso3;
