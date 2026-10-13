# IEA Teaching Dataset — Codebook

**Source:** International Environmental Agreements Database Project (IEADB), hosted by Université Laval, https://www.iea.ulaval.ca. Data described in Mitchell, R. B., L. B. Andonova, M. Axelrod, J. Balsiger, T. Bernauer, J. F. Green, J. Hollway, R. E. Kim and J.-F. Morin (2020), "What We Know (and Could Know) About International Environmental Agreements," *Global Environmental Politics* 20(1): 103–121, https://doi.org/10.1162/glep_a_00544. The IEADB requires users to cite both.

**Snapshot:** IEADB weekly release of 2026-10-08, downloaded 2026-10-13. The live database is regenerated every week, so this frozen copy keeps the numbers in lessons and labs stable. It was built by `scripts/build_iea_data.R`. Re-running that script pulls the *current* release.

**Provenance and terms of use:** These data come from the IEADB, created by Professor Ronald Mitchell at the University of Oregon and now hosted by Université Laval. Use of the data is subject to the IEADB's terms (https://www.iea.ulaval.ca and https://www.ulaval.ca/conditions), including the two citations above. **The files here are a simplified subset prepared for teaching, not the IEADB itself.** They keep only environmental agreements and a few columns, collapse each country's treaty actions to first signed / joined / left years, and add derived columns (`n_members`, the 2020 country measures). See "What was dropped" below. They are not a substitute for the full database: for research, download the current release from the IEADB website and cite it.

**Three linked tables:**

| File | One row is… | Rows | Key |
|---|---|---|---|
| `iea_agreements.csv` | one environmental agreement (treaty, protocol, or amendment) | 5,016 | `iea_id` |
| `iea_memberships.csv` | one country's participation in one agreement | 75,791 | `iea_id` + `country` |
| `iea_countries.csv` | one present-day country | 202 | `country` (also `iso3`) |

`iea_memberships` joins to `iea_agreements` by `iea_id` and to `iea_countries` by `country`.

Missing values (`NA`) are left in on purpose. They are real gaps in the record and are useful for teaching. The raw IEADB codes unknown dates as `1111-11-11`; those have all been converted to `NA`.

## `iea_agreements.csv`

| Column | Type | Description |
|---|---|---|
| `iea_id` | integer | IEADB agreement number. Unique per row. |
| `agreement_name` | character | Full name of the agreement. |
| `scope` | character | `Bilateral` (2 governments), `Multilateral` (3 or more), or `Other` (e.g., ministry-to-ministry, or an international organization and one country). |
| `instrument` | character | `Agreement`, `Protocol`, `Amendment`, or `Other` (memoranda, resolutions, etc.). |
| `subject` | character | Issue area, 11 categories (e.g., `Fish and fisheries`, `Pollution`, `Freshwater`). |
| `lineage` | character | The "family" of related agreements an agreement belongs to. A convention and its protocols and amendments share a lineage (e.g., `Ozone`). Some are `Not Yet Assigned`. `NA` for 35 agreements. |
| `year_signed` | integer | Year the agreement was concluded (signed or adopted). `NA` if unknown (130). |
| `year_in_force` | integer | Year the agreement entered into force. `NA` if it never did or the date is unknown (1,495, mostly bilateral agreements). |
| `terminated` | logical | `TRUE` if the agreement has since been terminated or replaced. `NA` for one agreement with a malformed date. |
| `n_members` | integer | Number of countries (or other parties) for which the agreement has ever entered into force, counted from `iea_memberships`. `NA` when the IEADB has no entry-into-force records for it (1,556). A few bilateral agreements have 1 or 3 members, as recorded in the source data. |

## `iea_memberships.csv`

Each country's action history on an agreement (signature, ratification, accession, withdrawal, …) is collapsed to the first year of each key step.

| Column | Type | Description |
|---|---|---|
| `iea_id` | integer | Agreement number; matches `iea_agreements$iea_id`. |
| `country` | character | Party name as recorded in the IEADB. Includes historical states (e.g., `Yugoslavia`, `Prussia`), sub-national units (e.g., `Germany (Bavaria)`), and the `European Union`. These 96 names (1,366 rows) have **no match** in `iea_countries`. |
| `year_country_signed` | integer | First year the country signed. Named differently from `iea_agreements$year_signed` (the year the agreement itself was concluded) so the two tables join cleanly. Mostly `NA`, because signatures are recorded for relatively few agreements. |
| `year_joined` | integer | First year the agreement entered into force for that country, i.e., it became a member. `NA` if it signed but never joined (or the year is unknown). |
| `year_left` | integer | First year the country withdrew or denounced the agreement. `NA` for nearly all rows, because most countries never leave. |

## `iea_countries.csv`

| Column | Type | Description |
|---|---|---|
| `country` | character | Country name, spelled as in `iea_memberships`. |
| `iso3` | character | ISO 3166 three-letter code. `NA` for Tibet. |
| `continent` | character | 8 regions: `Africa`, `Asia`, `Caribbean`, `Central America`, `Europe`, `North America`, `Oceania`, `South America`. |
| `subregion` | character | UN geographic subregion (e.g., `Western Africa`). |
| `oecd_joined` | integer | Year the country joined the OECD; `NA` if not a member. |
| `eu_joined` | integer | Year the country joined the EU (or its predecessor, the ECSC/EEC); `NA` if never. The United Kingdom keeps 1973 even though it left in 2020. |
| `population` | number | Population in 2020 (World Bank). `NA` for a few territories and microstates. |
| `gdp_per_capita` | integer | GDP per capita in 2020, constant 2015 US$ (World Bank). |
| `democracy_index` | number | V-Dem Liberal Democracy Index in 2020, 0 (least) to 1 (most democratic). `NA` for 29 countries V-Dem doesn't cover. |

## What was dropped from the raw files (and why)

- **Non-environmental and uncertain agreements.** The IEADB also lists related instruments that are not environmental agreements, or that it is unsure about. Only inclusion codes BEA, MEA, and OEA are kept.
- **About 30 treaty columns:** treaty text, URLs, coder notes, legacy codes, and secretariat names. The secretariat field is mostly "No known secretariat" or "not yet identified."
- **Raw membership actions.** There are 45 action types; they are collapsed to first signed / joined / left years.
- **Non-country rows in the country table** (aggregates, historical states, forecasts) and duplicate old names (`Czech Republic`, `Macedonia`).
- **Demographics for years other than 2020.**

## Teaching hooks

- **filter / select / arrange:** agreements signed between Stockholm (1972) and Rio (1992); the most widely joined multilateral agreements.
- **mutate:** `years_to_force = year_in_force - year_signed`; decade signed.
- **group_by / summarize / count:** agreements per `subject` or `scope`; mean and max `n_members` by subject.
- **Missing data:** `year_in_force` and `n_members` are missing mostly for bilateral agreements. Compare `mean()` with and without `na.rm = TRUE`.
- **ifelse / case_when:** size classes from `n_members` quartiles; `NA` handling differs between the two functions.
- **Joins:** memberships ↔ agreements (by `iea_id`) and memberships ↔ countries (by `country`). `left_join` and `inner_join` give different row counts because of historical states and the EU.
- **pivot_wider / pivot_longer:** countries joined per `continent` × `subject`; one row per country with a column per decade.
