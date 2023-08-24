constant: big_query_model_name {
  value: "YOUR_PROJECT_NAME.DATASET_NAME.MODEL_NAME"
}

constant: generate_text_table_name {
  value: "bigquery-public-data.cfpb_complaints.complaint_database"
}

constant: generate_text_primary_key {
  value: "complaint_id"
}

constant: generate_text_text_field {
  value: "consumer_complaint_narrative"
}
