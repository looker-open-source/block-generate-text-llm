view: publications {
  sql_table_name: `patents-public-data.patents.publications` ;;

  dimension: abstract_localized {
    hidden: yes
    sql: ${TABLE}.abstract_localized ;;
  }

  dimension: application_kind {
    type: string
    description: "High-level kind of the application: A=patent; U=utility; P=provision; W= PCT; F=design; T=translation."
    sql: ${TABLE}.application_kind ;;
  }

  dimension: application_number {
    type: string
    description: "Patent application number (DOCDB compatible), eg: 'US-87124404-A'. This may not always be set."
    sql: ${TABLE}.application_number ;;
  }

  dimension: application_number_formatted {
    type: string
    description: "Application number, formatted to the patent office format where possible."
    sql: ${TABLE}.application_number_formatted ;;
  }

  dimension: art_unit {
    type: string
    description: "The USPTO art unit performing the examination (2159, etc)."
    sql: ${TABLE}.art_unit ;;
  }

  dimension: assignee {
    hidden: yes
    sql: ${TABLE}.assignee ;;
  }

  dimension: assignee_harmonized {
    hidden: yes
    sql: ${TABLE}.assignee_harmonized ;;
  }

  dimension: child {
    hidden: yes
    sql: ${TABLE}.child ;;
  }

  dimension: citation {
    hidden: yes
    sql: ${TABLE}.citation ;;
  }

  dimension: claims_localized {
    hidden: yes
    sql: ${TABLE}.claims_localized ;;
  }

  dimension: claims_localized_html {
    hidden: yes
    sql: ${TABLE}.claims_localized_html ;;
  }

  dimension: country_code {
    type: string
    description: "Country code, eg: 'US', 'EP', etc"
    sql: ${TABLE}.country_code ;;
  }

  dimension: cpc {
    hidden: yes
    sql: ${TABLE}.cpc ;;
  }

  dimension: description_localized {
    hidden: yes
    sql: ${TABLE}.description_localized ;;
  }

  dimension: description_localized_html {
    hidden: yes
    sql: ${TABLE}.description_localized_html ;;
  }

  dimension: entity_status {
    type: string
    description: "The USPTO entity status (large, small)."
    sql: ${TABLE}.entity_status ;;
  }

  dimension: examiner {
    hidden: yes
    sql: ${TABLE}.examiner ;;
  }

  dimension: family_id {
    type: string
    description: "Family ID (simple family). Grouping on family ID will return all publications associated with a simple patent family (all publications share the same priority claims)."
    sql: ${TABLE}.family_id ;;
  }

  dimension: fi {
    hidden: yes
    sql: ${TABLE}.fi ;;
  }

  dimension_group: filing {
    type: time
    description: "The filing date."
    sql: ${TABLE}.filing_date ;;
    timeframes: [date, month, year]
    datatype: yyyymmdd
  }

  dimension: fterm {
    hidden: yes
    sql: ${TABLE}.fterm ;;
  }

  dimension_group: grant {
    type: time
    description: "The grant date, or 0 if not granted."
    sql: ${TABLE}.grant_date ;;
    timeframes: [date, month, year]
    datatype: yyyymmdd
  }

  dimension: inventor {
    hidden: yes
    sql: ${TABLE}.inventor ;;
  }

  dimension: inventor_harmonized {
    hidden: yes
    sql: ${TABLE}.inventor_harmonized ;;
  }

  dimension: ipc {
    hidden: yes
    sql: ${TABLE}.ipc ;;
  }

  dimension: kind_code {
    type: string
    description: "Kind code, indicating application, grant, search report, correction, etc. These are different for each country."
    sql: ${TABLE}.kind_code ;;
  }

  dimension: locarno {
    hidden: yes
    sql: ${TABLE}.locarno ;;
  }

  dimension: parent {
    hidden: yes
    sql: ${TABLE}.parent ;;
  }

  dimension: pct_number {
    type: string
    description: "PCT number for this application if it was part of a PCT filing, eg: 'PCT/EP2008/062623'."
    sql: ${TABLE}.pct_number ;;
  }

  dimension: priority_claim {
    hidden: yes
    sql: ${TABLE}.priority_claim ;;
  }

  dimension_group: priority {
    type: time
    description: "The earliest priority date from the priority claims, or the filing date."
    sql: ${TABLE}.priority_date ;;
    timeframes: [date, month, year]
    datatype: yyyymmdd
  }

  dimension_group: publication {
    type: time
    description: "The publication date."
    sql: ${TABLE}.publication_date ;;
    timeframes: [date, month, year]
    datatype: yyyymmdd
  }

  dimension: publication_number {
    type: string
    description: "Patent publication number (DOCDB compatible), eg: 'US-7650331-B1'"
    sql: ${TABLE}.publication_number ;;
  }

  dimension: spif_application_number {
    type: string
    description: "SPIF standard (spif.group) application number, after 2000"
    sql: ${TABLE}.spif_application_number ;;
  }

  dimension: spif_publication_number {
    type: string
    description: "SPIF standard (spif.group) publication number, after 2000"
    sql: ${TABLE}.spif_publication_number ;;
  }

  dimension: title_localized {
    hidden: yes
    sql: ${TABLE}.title_localized ;;
  }

  dimension: uspc {
    hidden: yes
    sql: ${TABLE}.uspc ;;
  }

  dimension: title_text {
    type: string
    sql:  ${TABLE}.title_localized[SAFE_OFFSET(0)].text ;;
    html:<div style="white-space:pre">{{value}}</div>;;
    group_label: "Text"
  }

  dimension: abstract_text {
    type: string
    sql:  ${TABLE}.abstract_localized[SAFE_OFFSET(0)].text ;;
    html:<div style="white-space:pre">{{value}}</div>;;
    group_label: "Text"
  }

  dimension: claims_text {
    type: string
    sql:  ${TABLE}.claims_localized[SAFE_OFFSET(0)].text ;;
    html:<div style="white-space:pre">{{value}}</div>;;
    group_label: "Text"
  }

  dimension: description_text {
    type: string
    sql:  ${TABLE}.description_localized[SAFE_OFFSET(0)].text ;;
    html:<div style="white-space:pre">{{value}}</div>;;
    group_label: "Text"
  }

  measure: count {
    type: count
  }
}
