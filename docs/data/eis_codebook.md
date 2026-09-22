# EIS Teaching Dataset — Codebook

**Source:** U.S. EPA Environmental Impact Statement (EIS) filing database (public EIS record API).
**What a row is:** one EIS filing (a Draft, Final, or supplemental statement) submitted to EPA under the National Environmental Policy Act (NEPA).
**Rows:** 16,784  **Columns:** 14  **Coverage:** filings from 1987-01 through 2026-01.

Missing values (`NA`) are left in on purpose — they are real (e.g., older records with no EPA rating, filings with no comment letter) and are good for teaching missingness.

| Column | Type | Description |
|---|---|---|
| `eis_id` | integer | Unique EPA record ID for the filing. One per row. |
| `title` | character | Title of the project / proposed action. Free text. |
| `document_type` | character | Stage of the statement: `Draft`, `Final`, `Draft Supplement`, `Final Supplement`, `Revised Draft`, etc. (30 categories). |
| `lead_agency` | character | Federal agency responsible for the EIS (e.g., `Forest Service`, `Federal Highway Administration`, `U.S. Army Corps of Engineers`). |
| `state` | character | Primary U.S. state, 2-letter code. `NA` when unspecified. |
| `all_states` | character | All states the action touches, comma-separated (e.g., `"CA, NV, AZ"`). Good for `stringr`/`tidyr::separate_rows`. |
| `filed_date` | Date | Date the filing was submitted to EPA. |
| `filed_year` | integer | Year of `filed_date` (convenience column for grouping). |
| `federal_register_date` | Date | Date the notice was published in the Federal Register. |
| `comment_letter_date` | Date | Date of EPA's comment letter on the filing. `NA` if none. |
| `comment_due_date` | Date | Deadline for public comments. |
| `epa_impact` | character | EPA's rating of the **environmental impact** of the proposed action, decoded from EPA's rating code: `Lack of Objections`, `Environmental Concerns`, `Environmental Objections`, `Environmentally Unsatisfactory`. `NA` if not rated / code unrecognized. |
| `epa_adequacy` | integer | EPA's rating of the **adequacy of the EIS document**: `1` = Adequate, `2` = Insufficient Information, `3` = Inadequate. `NA` if not rated. |
| `attachment_count` | integer | Number of documents attached to the filing (0–253). |

## EPA rating background (for `epa_impact` / `epa_adequacy`)
EPA rates each draft EIS on two axes. The **impact** axis (LO / EC / EO / EU) rates the proposed action; the **adequacy** axis (1 / 2 / 3) rates how complete the statement is. In the raw data these were combined into one cryptic code (e.g., `EC2` = "Environmental Concerns" + "Insufficient Information"). They have been split into two clear columns here. Final EISs and older records are often unrated, hence the `NA`s.

## What was dropped from the raw file (and why)
- `status` — constant (`"Signed"` for every row); no information.
- `uniqueIdentificationNumber` — 99% missing.
- `ceqNumber` — near-unique secondary ID, not needed for teaching.
- `ammendedNoticeDate`, `ammendedNoticeText`, `supplementalInformation`, `noticeOfIntent` — 90%+ missing free text.
- `cooperatingAgencies` — messy nested free-text lists.
- `_attachments_json`, `_zipLinkMetadata_json` — raw JSON blobs (kept only as the `attachment_count` summary).

## Teaching hooks
- **dplyr / summarise:** filings per `lead_agency`, per `state`, per `filed_year`.
- **lubridate:** parse dates, compute `comment_due_date - filed_date` review windows.
- **ggplot2:** filings over time; agency comparisons; state maps.
- **forcats:** collapse the 30 `document_type` levels; order `epa_impact`.
- **stringr / tidyr:** `separate_rows(all_states, sep = ", ")` for multi-state analysis.
- **Missingness:** why `epa_impact`/`epa_adequacy` are `NA` for Finals and older filings.
