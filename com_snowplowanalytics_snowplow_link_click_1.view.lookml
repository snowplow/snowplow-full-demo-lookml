- view: com_snowplowanalytics_snowplow_link_click_1
  sql_table_name: atomic.com_snowplowanalytics_snowplow_link_click_1
  fields:

  - dimension: element_classes
    sql: ${TABLE}.element_classes

  - dimension: element_id
    sql: ${TABLE}.element_id

  - dimension: element_target
    sql: ${TABLE}.element_target

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

  - dimension: target_url
    sql: ${TABLE}.target_url

  - measure: count
    type: count
    drill_fields: [schema_name]

