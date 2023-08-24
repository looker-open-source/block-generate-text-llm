view: generate_text {
  derived_table: {
    sql:
        SELECT
          @{generate_text_primary_key}
          , prompt
          , ml_generate_text_result
        FROM ML.GENERATE_TEXT(
          MODEL `@{big_query_model_name}`, (
            SELECT
              @{generate_text_primary_key}
              , CONCAT({% parameter prompt_input %},': """', @{generate_text_text_field}, '"""') AS prompt
            FROM @{generate_text_table_name} AS model_query
            WHERE TRUE
              {% if complaint_database.company_name._is_filtered %} AND {% condition complaint_database.company_name %} model_query.company_name {% endcondition %} {% endif %}
              {% if complaint_database.company_public_response._is_filtered %} AND {% condition complaint_database.company_public_response %} model_query.company_public_response {% endcondition %} {% endif %}
              {% if complaint_database.company_response_to_consumer._is_filtered %} AND {% condition complaint_database.company_response_to_consumer %} model_query.company_response_to_consumer {% endcondition %} {% endif %}
              {% if complaint_database.complaint_id._is_filtered %} AND {% condition complaint_database.complaint_id %} model_query.complaint_id {% endcondition %} {% endif %}
              {% if complaint_database.consumer_complaint_narrative._is_filtered %} AND {% condition complaint_database.consumer_complaint_narrative %} model_query.consumer_complaint_narrative {% endcondition %} {% endif %}
              {% if complaint_database.consumer_consent_provided._is_filtered %} AND {% condition complaint_database.consumer_consent_provided %} model_query.consumer_consent_provided {% endcondition %} {% endif %}
              {% if complaint_database.consumer_disputed._is_filtered %} AND {% condition complaint_database.consumer_disputed %} model_query.consumer_disputed {% endcondition %} {% endif %}
              {% if complaint_database.issue._is_filtered %} AND {% condition complaint_database.issue %} model_query.issue {% endcondition %} {% endif %}
              {% if complaint_database.product._is_filtered %} AND {% condition complaint_database.product %} model_query.product {% endcondition %} {% endif %}
              {% if complaint_database.state._is_filtered %} AND {% condition complaint_database.state %} model_query.state {% endcondition %} {% endif %}
              {% if complaint_database.subissue._is_filtered %} AND {% condition complaint_database.subissue %} model_query.subissue {% endcondition %} {% endif %}
              {% if complaint_database.submitted_via._is_filtered %} AND {% condition complaint_database.submitted_via %} model_query.submitted_via {% endcondition %} {% endif %}
              {% if complaint_database.subproduct._is_filtered %} AND {% condition complaint_database.subproduct %} model_query.subproduct {% endcondition %} {% endif %}
              {% if complaint_database.tags._is_filtered %} AND {% condition complaint_database.tags %} model_query.tags {% endcondition %} {% endif %}
              {% if complaint_database.timely_response._is_filtered %} AND {% condition complaint_database.timely_response %} model_query.timely_response {% endcondition %} {% endif %}
              {% if complaint_database.zip_code._is_filtered %} AND {% condition complaint_database.zip_code %} model_query.zip_code {% endcondition %} {% endif %}
              {% if complaint_database.date_received_date._is_filtered %} AND {% condition complaint_database.date_received_date %} model_query.date_received {% endcondition %} {% endif %}
              {% if complaint_database.date_received_year._is_filtered %} AND {% condition complaint_database.date_received_year %} model_query.date_received {% endcondition %} {% endif %}
              {% if complaint_database.date_sent_to_company_date._is_filtered %} AND {% condition complaint_database.date_sent_to_company_date %} model_query.date_sent_to_company {% endcondition %} {% endif %}
              {% if complaint_database.date_sent_to_company_year._is_filtered %} AND {% condition complaint_database.date_sent_to_company_year %} model_query.date_sent_to_company {% endcondition %} {% endif %}
          ),
          STRUCT(
            {% if max_output_tokens._parameter_value > 1024 or max_output_tokens._parameter_value < 1 %} 50 {% else %} {% parameter max_output_tokens %} {% endif %} AS max_output_tokens
            , {% if temperature._parameter_value > 1 or temperature._parameter_value < 0 %} 1.0 {% else %} {% parameter temperature %} {% endif %} AS temperature
            , {% if top_k._parameter_value > 40 or top_k._parameter_value < 1 %} 40 {% else %} {% parameter top_k %} {% endif %} AS top_k
            , {% if top_p._parameter_value > 1 or top_p._parameter_value < 0 %} 1.0 {% else %} {% parameter top_p %} {% endif %} AS top_p
          )
        )
    ;;
  }

  parameter: prompt_input {
    label: " Prompt"
    type: string
    suggestions: [
      "Perform sentiment analysis on the following text"
      , "Extract the named entities from the text and output the named entities only"
      , "Translate the text into Spanish"
      , "Summarize the text into one sentence"
      , "Classify the text into one of following categories: [Positive, Negative], and only output one word"
    ]
  }

  # https://cloud.google.com/bigquery/docs/reference/standard-sql/bigqueryml-syntax-generate-text#arguments

  parameter: max_output_tokens {
    type: number
    default_value: "50"
    description: "max_output_tokens is an INT64 value in the range [1,1024] that sets the maximum number of tokens that the model outputs.
      Specify a lower value for shorter responses and a higher value for longer responses. The default is 50."
  }

  parameter: temperature {
    type: number
    default_value: "1.0"
    description: "temperature is a FLOAT64 value in the range [0.0,1.0] that is used for sampling during the response generation,
      which occurs when top_k and top_p are applied. It controls the degree of randomness in token selection. Lower temperature
      values are good for prompts that require a more deterministic and less open-ended or creative response, while higher
      temperature values can lead to more diverse or creative results. A temperature value of 0 is deterministic,
      meaning that the highest probability response is always selected. The default is 1.0."
  }

  parameter: top_k {
    type: number
    default_value: "40"
    description: "top_k is an INT64 value in the range [1,40] that changes how the model selects tokens for output.
      Specify a lower value for less random responses and a higher value for more random responses. The default is 40."
  }

  parameter: top_p {
    type: number
    default_value: "1.0"
    description: "top_p is a FLOAT64 value in the range [0.0,1.0] that changes how the model selects tokens for output.
      Specify a lower value for less random responses and a higher value for more random responses. The default is 1.0."
  }

  dimension: complaint_id {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}.complaint_id ;;
  }

# ml_generate_text_result returns JSON object in following format:
#
# {
#   "predictions": [
#     {
#       "citationMetadata": { "citations": [] },
#       "content": "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt...",
#       "safetyAttributes": { "blocked": false, "categories": [], "scores": [] }
#     }
#   ]
# }

  dimension:  text_result {
    type: string
    sql:  JSON_VALUE(${TABLE}.ml_generate_text_result, '$.predictions[0].content') ;;
    html:<div style="white-space:pre">{{value}}</div>;;
  }

  dimension:  blocked {
    type: string
    sql:  JSON_VALUE(${TABLE}.ml_generate_text_result, '$.predictions[0].safetyAttributes.blocked') ;;
    html:<div style="white-space:pre">{{value}}</div>;;
    group_label: "Safety Attributes"
  }

  dimension:  categories {
    type: string
    sql:  ARRAY_TO_STRING(JSON_VALUE_ARRAY(${TABLE}.ml_generate_text_result, '$.predictions[0].safetyAttributes.categories'), ', ') ;;
    html:<div style="white-space:pre">{{value}}</div>;;
    group_label: "Safety Attributes"
  }

  dimension:  scores {
    type: string
    sql:  ARRAY_TO_STRING(JSON_VALUE_ARRAY(${TABLE}.ml_generate_text_result, '$.predictions[0].safetyAttributes.scores'), ', ') ;;
    html:<div style="white-space:pre">{{value}}</div>;;
    group_label: "Safety Attributes"
  }
}
