view: patent_summary {
  derived_table: {
    sql:
    SELECT
      publication_number
      , abstract_text
      , ml_generate_text_result
    FROM ML.GENERATE_TEXT(
        MODEL `@{big_query_model_name}`,
        ( SELECT
            publication_number
            , abstract_localized[SAFE_OFFSET(0)].text AS abstract_text
            , CONCAT(
              {% parameter prompt_input %}
              , '"""'
              , 'Abtract Text: '
              , abstract_localized[SAFE_OFFSET(0)].text
              , '"""'
              ,'Summary: '
              ) AS prompt
          FROM `patents-public-data.patents.publications` TABLESAMPLE SYSTEM (0.5 PERCENT)
          WHERE country_code = 'US'
          AND abstract_localized[SAFE_OFFSET(0)].text IS NOT NULL
          AND publication_date > 20230101
        ),
        STRUCT(
          65 AS max_output_tokens -- 1.3 average tokens per word, therefore summary will be approximately 50 words max
          , 0.5 AS temperature
          , 15 AS top_k
          , 0.9 AS top_p
        )
    )
    ;;
    datagroup_trigger: patent_publications_no_update
  }

  # update prompt here to change generate text output results
  parameter: prompt_input {
    hidden: yes
    default_value: "Please create a summary using simple terms for this patent information based on the following Abstract Text:"
  }

  dimension: publication_number {
    type: string
    description: "Patent publication number (DOCDB compatible), eg: 'US-7650331-B1'"
    sql: ${TABLE}.publication_number ;;
    hidden: yes
  }

  dimension: abstract_text {
    type: string
    sql:  ${TABLE}.abstract_localized[SAFE_OFFSET(0)].text ;;
    html:<div style="white-space:pre">{{value}}</div>;;
    group_label: "Text"
    hidden: yes
  }

  dimension: claims_text {
    type: string
    sql:  ${TABLE}.claims_localized[SAFE_OFFSET(0)].text ;;
    html:<div style="white-space:pre">{{value}}</div>;;
    group_label: "Text"
    hidden: yes
  }

  dimension:  text_result {
    type: string
    sql:  JSON_VALUE(${TABLE}.ml_generate_text_result, '$.predictions[0].content') ;;
    html:<div style="white-space:pre">{{value}}</div>;;
    label: "Generate Text Result"
    view_label: "Publications"
    group_label: "Text"
  }

  dimension:  blocked {
    type: string
    sql:  JSON_VALUE(${TABLE}.ml_generate_text_result, '$.predictions[0].safetyAttributes.blocked') ;;
    html:<div style="white-space:pre">{{value}}</div>;;
    view_label: "Publications"
    group_label: "Generate Text"
    hidden: yes
  }

  dimension:  categories {
    type: string
    sql:  ARRAY_TO_STRING(JSON_VALUE_ARRAY(${TABLE}.ml_generate_text_result, '$.predictions[0].safetyAttributes.categories'), ', ') ;;
    html:<div style="white-space:pre">{{value}}</div>;;
    view_label: "Publications"
    group_label: "Generate Text"
    hidden: yes
  }

  dimension:  scores {
    type: string
    sql:  ARRAY_TO_STRING(JSON_VALUE_ARRAY(${TABLE}.ml_generate_text_result, '$.predictions[0].safetyAttributes.scores'), ', ') ;;
    html:<div style="white-space:pre">{{value}}</div>;;
    view_label: "Publications"
    group_label: "Generate Text"
    hidden: yes
  }
}
