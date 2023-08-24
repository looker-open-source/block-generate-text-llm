connection: "YOUR_BQ_CONNECTION_NAME"

include: "./*.view.lkml"

datagroup: consumer_complaint_database_default_datagroup {
  max_cache_age: "1 hour"
}

persist_with: consumer_complaint_database_default_datagroup

explore: complaint_database {
  always_filter: {
    filters: [
      generate_text.prompt_input: "",
      generate_text.max_output_tokens: "",
      generate_text.temperature: "",
      generate_text.top_k: "",
      generate_text.top_p: ""
    ]
  }
  join: generate_text {
    type: left_outer
    relationship: one_to_one
    sql_on: complaint_database.@{generate_text_primary_key} = generate_text.@{generate_text_primary_key} ;;
  }
}
