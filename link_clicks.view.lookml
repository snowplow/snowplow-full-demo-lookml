- view: link_clicks
  sql_table_name: snowplow_pivots.link_clicks
  fields:

  - dimension_group: collector_tstamp
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.collector_tstamp

  - dimension: domain_sessionidx
    type: number
    sql: ${TABLE}.domain_sessionidx

  - dimension: domain_userid
    sql: ${TABLE}.domain_userid

  - dimension_group: dvce_tstamp
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.dvce_tstamp

  - dimension: link_element_classes
    sql: ${TABLE}.link_element_classes

  - dimension: link_element_id
    sql: ${TABLE}.link_element_id

  - dimension: link_element_target
    sql: ${TABLE}.link_element_target

  - dimension: link_target_is_github_snowplow
    type: yesno
    sql: ${TABLE}.link_target_is_github_snowplow

  - dimension: link_target_is_internal_click
    type: yesno
    sql: ${TABLE}.link_target_is_internal_click

  - dimension: link_target_url
    sql: ${TABLE}.link_target_url

  - dimension: link_target_url_host
    sql: ${TABLE}.link_target_url_host

  - dimension: page_urlhost
    sql: ${TABLE}.page_urlhost

  - dimension: page_urlpath
    sql: ${TABLE}.page_urlpath

  - measure: count
    type: count
    drill_fields: []

