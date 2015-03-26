- view: org_schema_web_page_1
  sql_table_name: atomic.org_schema_web_page_1
  fields:

  - dimension: author
    sql: ${TABLE}.author

  - dimension: breadcrumb
    sql: ${TABLE}.breadcrumb

  - dimension_group: date_created
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.date_created

  - dimension_group: date_modified
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.date_modified

  - dimension_group: date_published
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.date_published

  - dimension: genre
    sql: ${TABLE}.genre

  - dimension: in_language
    sql: ${TABLE}.in_language

  - dimension: keywords
    sql: ${TABLE}.keywords

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
    drill_fields: [schema_name]

