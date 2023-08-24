connection: "YOUR_BQ_CONNECTION_NAME"

include: "./*.view.lkml"

datagroup: patent_publications_default {
  max_cache_age: "1 hour"
}

datagroup: patent_publications_no_update {
  sql_trigger: SELECT 1 ;;
}

persist_with: patent_publications_default

explore: patent_summary {
  join: publications {
    type: left_outer
    relationship: one_to_one
    sql_on: ${patent_summary.publication_number} = ${publications.publication_number} ;;
  }
}

explore: publications {
  hidden: yes
}
