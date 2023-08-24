view: complaint_database {
  sql_table_name: `bigquery-public-data.cfpb_complaints.complaint_database` ;;

  dimension: company_name {
    type: string
    description: "Name of the company identified in the complaint by the consumer"
    sql: ${TABLE}.company_name ;;
  }

  dimension: company_public_response {
    type: string
    description: "The company's optional public-facing response to a consumer's complaint"
    sql: ${TABLE}.company_public_response ;;
  }

  dimension: company_response_to_consumer {
    type: string
    description: "The response from the company about this complaint"
    sql: ${TABLE}.company_response_to_consumer ;;
  }

  dimension: complaint_id {
    primary_key: yes
    type: string
    description: "Unique ID for complaints registered with the CFPB"
    sql: ${TABLE}.complaint_id ;;
  }

  dimension: consumer_complaint_narrative {
    type: string
    description: "A description of the complaint provided by the consumer"
    sql: ${TABLE}.consumer_complaint_narrative ;;
    html:<div style="white-space:pre">{{value}}</div>;;
  }

  dimension: consumer_consent_provided {
    type: string
    description: "Identifies whether the consumer opted in to publish their complaint narrative"
    sql: ${TABLE}.consumer_consent_provided ;;
  }

  dimension: consumer_disputed {
    type: yesno
    description: "Whether the consumer disputed the company's response"
    sql: ${TABLE}.consumer_disputed ;;
  }

  dimension_group: date_received {
    type: time
    description: "Date the complaint was received by the CPFB"
    timeframes: [raw, date, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date_received ;;
  }

  dimension_group: date_sent_to_company {
    type: time
    description: "The date the CFPB sent the complaint to the company"
    timeframes: [raw, date, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date_sent_to_company ;;
  }

  dimension: issue {
    type: string
    description: "The issue the consumer identified in the complaint"
    sql: ${TABLE}.issue ;;
  }

  dimension: product {
    type: string
    description: "The type of product the consumer identified in the complaint"
    sql: ${TABLE}.product ;;
  }

  dimension: state {
    type: string
    description: "Two letter postal abbreviation of the state of the mailing address provided by the consumer"
    sql: ${TABLE}.state ;;
  }

  dimension: subissue {
    type: string
    description: "The sub-issue the consumer identified in the complaint"
    sql: ${TABLE}.subissue ;;
  }

  dimension: submitted_via {
    type: string
    description: "How the complaint was submitted to the CFPB"
    sql: ${TABLE}.submitted_via ;;
  }

  dimension: subproduct {
    type: string
    description: "The type of sub-product the consumer identified in the complaint"
    sql: ${TABLE}.subproduct ;;
  }

  dimension: tags {
    type: string
    description: "Data that supports easier searching and sorting of complaints"
    sql: ${TABLE}.tags ;;
  }

  dimension: timely_response {
    type: yesno
    description: "Indicates whether the company gave a timely response or not"
    sql: ${TABLE}.timely_response ;;
  }

  dimension: zip_code {
    type: zipcode
    description: "The mailing ZIP code provided by the consumer"
    sql: LEFT(${TABLE}.zip_code, 5) ;;
  }
  measure: count {
    type: count
    drill_fields: [company_name]
  }
}
