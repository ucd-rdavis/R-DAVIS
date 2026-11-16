# Wildfire Air Quality Teaching Dataset — Codebook

**Source:** Aguilera, R. & Benmarhnia, T. *Daily Total and Wildfire Concentrations of PM10 and Ozone for California ZIP Codes (2006-2020)*. Harvard Dataverse, V3.1. https://doi.org/10.7910/DVN/FYW1VU. The concentrations are machine-learning estimates built from air-monitor data, satellite aerosol optical depth, land cover, and weather. The wildfire-specific part was separated from the total using NOAA Hazard Mapping System smoke plumes and CalFIRE fire perimeters.

**Associated paper:** Aguilera R., Letellier N., Basu R., Vaidyanathan A., Casey J.A., Gershunov A., Diao M., Benmarhnia T. (2025). Effects of multiple wildfire smoke pollutants (PM2.5, PM10 and ozone) on respiratory and cardiovascular hospitalizations in California (2006-2019). *GeoHealth*, 9(12), e2025GH001510.

**License:** CC0 1.0 (public domain). Please still cite the dataset and the paper.

**Snapshot:** downloaded 2026-11-16 from the ZIP-code files (`CAzip_wf_pm10_2006to2020_Aug2025.csv`, `CAzip_wf_ozone_2006to2020_Aug2025.csv`) and built by `scripts/build_ca_wildfire_air_data.R`.

**This is a simplified subset for teaching, not the published dataset itself.** The original covers all 1,778 California ZIP codes (and census tracts) and runs to about 9.7 million rows per pollutant. This subset keeps one ZIP code for each of six places, joins the PM10 and ozone files, rounds values to one decimal place, and converts ozone from ppm to ppb. For research, download the original from Dataverse.

## `ca_wildfire_air.csv`

One row is one place on one day. 32,874 rows: 6 places × 5,479 days (2006-01-01 to 2020-12-31). There are no missing values.

| Column | Type | Description |
|---|---|---|
| `city` | character | Place name: Davis, Fresno, Los Angeles, Paradise, Redding, or Santa Rosa. |
| `zip` | numeric | The ZIP code the estimates are for: 95616 (Davis), 93721 (Fresno, downtown), 90012 (Los Angeles, downtown), 95969 (Paradise), 96001 (Redding), 95404 (Santa Rosa). |
| `date` | date | Day of the estimate. |
| `year` | integer | Year, 2006–2020. |
| `pm10` | numeric | Total daily PM10 (particulate matter 10 micrometres or smaller), µg/m³. |
| `pm10_fire` | numeric | The part of `pm10` the model attributes to wildfire smoke, µg/m³. 0 on days with no smoke. |
| `ozone` | numeric | Total daily maximum ozone, parts per billion (ppb). The source gives it in ppm (`max.o3`). |
| `ozone_fire` | numeric | The part of `ozone` the model attributes to wildfire smoke, ppb. 0 on days with no smoke. |

`pm10 - pm10_fire` is the non-wildfire PM10 (dust, traffic, industry, and so on). In the lessons, a "smoke day" is a day with `pm10_fire > 0`.

Paradise was largely destroyed by the Camp Fire on 2018-11-08. Its highest `pm10_fire` (232.3 µg/m³) is on 2018-11-15.
