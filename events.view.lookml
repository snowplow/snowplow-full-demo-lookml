- view: events
  sql_table_name: atomic.events
  fields:

  - dimension: event_id
    primary_key: true
    sql: ${TABLE}.event_id

  - dimension: app_id
    sql: ${TABLE}.app_id

  - dimension: br_colordepth
    sql: ${TABLE}.br_colordepth

  - dimension: br_cookies
    type: yesno
    sql: ${TABLE}.br_cookies

  - dimension: br_family
    sql: ${TABLE}.br_family

  - dimension: br_features_director
    type: yesno
    sql: ${TABLE}.br_features_director

  - dimension: br_features_flash
    type: yesno
    sql: ${TABLE}.br_features_flash

  - dimension: br_features_gears
    type: yesno
    sql: ${TABLE}.br_features_gears

  - dimension: br_features_java
    type: yesno
    sql: ${TABLE}.br_features_java

  - dimension: br_features_pdf
    type: yesno
    sql: ${TABLE}.br_features_pdf

  - dimension: br_features_quicktime
    type: yesno
    sql: ${TABLE}.br_features_quicktime

  - dimension: br_features_realplayer
    type: yesno
    sql: ${TABLE}.br_features_realplayer

  - dimension: br_features_silverlight
    type: yesno
    sql: ${TABLE}.br_features_silverlight

  - dimension: br_features_windowsmedia
    type: yesno
    sql: ${TABLE}.br_features_windowsmedia

  - dimension: br_lang
    sql: ${TABLE}.br_lang

  - dimension: br_name
    sql: ${TABLE}.br_name

  - dimension: br_renderengine
    sql: ${TABLE}.br_renderengine

  - dimension: br_type
    sql: ${TABLE}.br_type

  - dimension: br_version
    sql: ${TABLE}.br_version

  - dimension: br_viewheight
    type: int
    sql: ${TABLE}.br_viewheight

  - dimension: br_viewwidth
    type: int
    sql: ${TABLE}.br_viewwidth

  - dimension_group: collector_tstamp
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.collector_tstamp

  - dimension: doc_charset
    sql: ${TABLE}.doc_charset

  - dimension: doc_height
    type: int
    sql: ${TABLE}.doc_height

  - dimension: doc_width
    type: int
    sql: ${TABLE}.doc_width

  - dimension: domain_sessionidx
    type: number
    sql: ${TABLE}.domain_sessionidx

  - dimension: domain_userid
    sql: ${TABLE}.domain_userid

  - dimension: dvce_ismobile
    type: yesno
    sql: ${TABLE}.dvce_ismobile

  - dimension: dvce_screenheight
    type: int
    sql: ${TABLE}.dvce_screenheight

  - dimension: dvce_screenwidth
    type: int
    sql: ${TABLE}.dvce_screenwidth

  - dimension_group: dvce_tstamp
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.dvce_tstamp

  - dimension: dvce_type
    sql: ${TABLE}.dvce_type

  - dimension_group: etl_tstamp
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.etl_tstamp

  - dimension: event
    sql: ${TABLE}.event

  - dimension: geo_city
    sql: ${TABLE}.geo_city

  - dimension: geo_country
    sql: ${TABLE}.geo_country

  - dimension: geo_region
    sql: ${TABLE}.geo_region

  - dimension: geo_region_name
    sql: ${TABLE}.geo_region_name

  - dimension: ip_domain
    sql: ${TABLE}.ip_domain

  - dimension: ip_isp
    sql: ${TABLE}.ip_isp

  - dimension: ip_netspeed
    sql: ${TABLE}.ip_netspeed

  - dimension: ip_organization
    sql: ${TABLE}.ip_organization

  - dimension: mkt_campaign
    sql: ${TABLE}.mkt_campaign

  - dimension: mkt_content
    sql: ${TABLE}.mkt_content

  - dimension: mkt_medium
    sql: ${TABLE}.mkt_medium

  - dimension: mkt_source
    sql: ${TABLE}.mkt_source

  - dimension: mkt_term
    sql: ${TABLE}.mkt_term

  - dimension: name_tracker
    sql: ${TABLE}.name_tracker

  - dimension: network_userid
    sql: ${TABLE}.network_userid

  - dimension: os_family
    sql: ${TABLE}.os_family

  - dimension: os_manufacturer
    sql: ${TABLE}.os_manufacturer

  - dimension: os_name
    sql: ${TABLE}.os_name

  - dimension: os_timezone
    sql: ${TABLE}.os_timezone

  - dimension: page_referrer
    sql: ${TABLE}.page_referrer

  - dimension: page_title
    sql: ${TABLE}.page_title

  - dimension: page_url
    sql: ${TABLE}.page_url

  - dimension: page_urlfragment
    sql: ${TABLE}.page_urlfragment

  - dimension: page_urlhost
    sql: ${TABLE}.page_urlhost

  - dimension: page_urlpath
    sql: ${TABLE}.page_urlpath

  - dimension: page_urlport
    type: int
    sql: ${TABLE}.page_urlport

  - dimension: page_urlquery
    sql: ${TABLE}.page_urlquery

  - dimension: page_urlscheme
    sql: ${TABLE}.page_urlscheme

  - dimension: platform
    sql: ${TABLE}.platform

  - dimension: pp_xoffset_max
    type: int
    sql: ${TABLE}.pp_xoffset_max

  - dimension: pp_xoffset_min
    type: int
    sql: ${TABLE}.pp_xoffset_min

  - dimension: pp_yoffset_max
    type: int
    sql: ${TABLE}.pp_yoffset_max

  - dimension: pp_yoffset_min
    type: int
    sql: ${TABLE}.pp_yoffset_min

  - dimension: refr_medium
    sql: ${TABLE}.refr_medium

  - dimension: refr_source
    sql: ${TABLE}.refr_source

  - dimension: refr_term
    sql: ${TABLE}.refr_term

  - dimension: refr_urlfragment
    sql: ${TABLE}.refr_urlfragment

  - dimension: refr_urlhost
    sql: ${TABLE}.refr_urlhost

  - dimension: refr_urlpath
    sql: ${TABLE}.refr_urlpath

  - dimension: refr_urlport
    type: int
    sql: ${TABLE}.refr_urlport

  - dimension: refr_urlquery
    sql: ${TABLE}.refr_urlquery

  - dimension: refr_urlscheme
    sql: ${TABLE}.refr_urlscheme

  - dimension: se_action
    sql: ${TABLE}.se_action

  - dimension: se_category
    sql: ${TABLE}.se_category

  - dimension: se_label
    sql: ${TABLE}.se_label

  - dimension: se_property
    sql: ${TABLE}.se_property

  - dimension: se_value
    type: number
    sql: ${TABLE}.se_value

  - dimension: ti_category
    sql: ${TABLE}.ti_category

  - dimension: ti_name
    sql: ${TABLE}.ti_name

  - dimension: ti_orderid
    sql: ${TABLE}.ti_orderid

  - dimension: ti_price
    type: number
    sql: ${TABLE}.ti_price

  - dimension: ti_quantity
    type: int
    sql: ${TABLE}.ti_quantity

  - dimension: ti_sku
    sql: ${TABLE}.ti_sku

  - dimension: tr_affiliation
    sql: ${TABLE}.tr_affiliation

  - dimension: tr_city
    sql: ${TABLE}.tr_city

  - dimension: tr_country
    sql: ${TABLE}.tr_country

  - dimension: tr_orderid
    sql: ${TABLE}.tr_orderid

  - dimension: tr_shipping
    type: number
    sql: ${TABLE}.tr_shipping

  - dimension: tr_state
    sql: ${TABLE}.tr_state

  - dimension: tr_tax
    type: number
    sql: ${TABLE}.tr_tax

  - dimension: tr_total
    type: number
    sql: ${TABLE}.tr_total

  - dimension: txn_id
    type: int
    sql: ${TABLE}.txn_id

  - dimension: user_fingerprint
    sql: ${TABLE}.user_fingerprint

  - dimension: user_id
    sql: ${TABLE}.user_id

  - dimension: user_ipaddress
    sql: ${TABLE}.user_ipaddress

  - dimension: useragent
    sql: ${TABLE}.useragent

  - dimension: v_collector
    sql: ${TABLE}.v_collector

  - dimension: v_etl
    sql: ${TABLE}.v_etl

  - dimension: v_tracker
    sql: ${TABLE}.v_tracker

  - measure: count
    type: count
    drill_fields: [event_id, geo_region_name, ti_name, br_name, os_name]

