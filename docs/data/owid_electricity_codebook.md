# Electricity Teaching Dataset — Codebook

**Source:** Our World in Data (OWID) energy dataset, legacy release, https://github.com/owid/energy-data. The electricity columns are compiled by OWID from Ember, *Yearly Electricity Data* (2026), https://ember-energy.org/data/yearly-electricity-data/, and the Energy Institute, *Statistical Review of World Energy* (2025), https://www.energyinst.org/statistical-review/. Population is OWID's population series.

**License:** CC BY 4.0. Cite as: Our World in Data, *Energy dataset*, based on Ember (2026) and Energy Institute Statistical Review of World Energy (2025).

**Snapshot:** downloaded 2026-11-15 and built by `scripts/build_owid_electricity_data.R`. OWID has marked this release as legacy and moved new work to https://catalog.ourworldindata.org/energy/owid_energy/; the electricity columns used here were last refreshed from Ember's April 2026 release. Re-running the script may change numbers quoted in the week 9 lesson.

**This is a simplified subset for teaching, not the OWID dataset itself.** It keeps countries only (no regions or income groups), years 2000–2024, and 15 of the original 130 columns. For research, download the current OWID release and cite its sources.

## `owid_electricity.csv`

One row is one country in one year. 5,459 rows, 220 countries.

| Column | Type | Description |
|---|---|---|
| `country` | character | Country name. |
| `iso_code` | character | ISO 3166-1 alpha-3 code. |
| `year` | integer | 2000–2024. |
| `population` | numeric | Population (people). |
| `electricity_generation` | numeric | Total electricity generated, terawatt-hours (TWh). |
| `coal_electricity` | numeric | Generation from coal, TWh. |
| `gas_electricity` | numeric | Generation from natural gas, TWh. |
| `oil_electricity` | numeric | Generation from oil, TWh. |
| `nuclear_electricity` | numeric | Generation from nuclear, TWh. |
| `hydro_electricity` | numeric | Generation from hydropower, TWh. |
| `wind_electricity` | numeric | Generation from wind, TWh. |
| `solar_electricity` | numeric | Generation from solar, TWh. |
| `biofuel_electricity` | numeric | Generation from bioenergy, TWh. |
| `other_renewable_electricity` | numeric | Generation from other renewables (mostly geothermal, also wave and tidal), TWh. Excludes bioenergy. This is OWID's `other_renewable_exc_biofuel_electricity`, renamed. |
| `carbon_intensity_elec` | numeric | Lifecycle greenhouse gas emissions per unit of electricity generated, grams of CO₂-equivalent per kilowatt-hour (gCO₂e/kWh). |

The nine source columns (`coal_electricity` through `other_renewable_electricity`) add up to `electricity_generation` wherever all are present.

**Units:** 1 TWh = 1,000 GWh = 1 billion kWh.

Missing values (`NA`) are left in. A few rows have `electricity_generation` of 0 (Lesotho, Niue), as recorded in the source.
