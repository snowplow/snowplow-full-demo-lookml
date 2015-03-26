- view: com_snowplowanalytics_snowplow_website_trial_form_submitted_1
  sql_table_name: atomic.com_snowplowanalytics_snowplow_website_trial_form_submitted_1
  fields:

  - dimension: company
    sql: ${TABLE}.company

  - dimension: email
    sql: ${TABLE}.email

  - dimension: events_per_month
    sql: ${TABLE}.events_per_month

  - dimension: name
    sql: ${TABLE}.name

  - dimension: ref_parent
    sql: ${TABLE}.ref_parent

  - dimension: ref_root
    sql: ${TABLE}.ref_root

  - dimension: ref_tree
    sql: ${TABLE}.ref_tree

  - dimension: root_id
    sql: ${TABLE}.root_id

  - dimension_group: root_tstamp
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.root_tstamp

  - dimension: schema_format
    sql: ${TABLE}.schema_format

  - dimension: schema_name
    sql: ${TABLE}.schema_name

  - dimension: schema_vendor
    sql: ${TABLE}.schema_vendor

  - dimension: schema_version
    sql: ${TABLE}.schema_version

  - measure: count
    type: count
    drill_fields: [schema_name, name]

