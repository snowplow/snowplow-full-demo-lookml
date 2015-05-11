# Copyright (c) 2013-2015 Snowplow Analytics Ltd. All rights reserved.
#
# This program is licensed to you under the Apache License Version 2.0,
# and you may not use this file except in compliance with the Apache License Version 2.0.
# You may obtain a copy of the Apache License Version 2.0 at http://www.apache.org/licenses/LICENSE-2.0.
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the Apache License Version 2.0 is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the Apache License Version 2.0 for the specific language governing permissions and limitations there under.
#
# Version: 3-0-0
#
# Authors: Yali Sassoon, Christophe Bogaert
# Copyright: Copyright (c) 2013-2015 Snowplow Analytics Ltd
# License: Apache License Version 2.0

- view: page_views
  sql_table_name: snowplow_pivots.page_views
  fields:
  
  # DIMENSIONS # 
  
  # User identifier
  
  - dimension: user_id
    sql: ${TABLE}.domain_userid
  
  # Page identifiers
  
  - dimension: page
    sql: ${TABLE}.page_urlhost || ${TABLE}.page_urlpath
  
  - dimension: page_host
    sql: ${TABLE}.page_urlhost
  
  - dimension: page_path
    sql: ${TABLE}.page_urlpath
  
  - dimension: rank
    type: int
    sql: ${TABLE}.page_view_rank
  
  # Page details
  
  - dimension: page_title
    sql: ${TABLE}.page_title
  
  - dimension: website_section
    sql_case:
      blog: ${TABLE}.w3_genre = 'blog'
      analytics: ${TABLE}.w3_genre = 'analytics'
      product: ${TABLE}.w3_genre = 'product'
      pricing: ${TABLE}.w3_genre = 'pricing'
      technology: ${TABLE}.w3_genre = 'technology'
      about: ${TABLE}.w3_genre = 'about'
      authors: ${TABLE}.w3_genre = 'authors'
      else: other
  
  - dimension: blog_author
    sql: ${TABLE}.w3_author
  
  - dimension: blog_breadcrumb
    sql_case:
      blog: ${TABLE}.w3_breadcrumb = '[\"blog\"]'
      other: ${TABLE}.w3_breadcrumb = '[\"blog\",\"other\"]'
      talks: ${TABLE}.w3_breadcrumb = '[\"blog\",\"talks\"]'
      research: ${TABLE}.w3_breadcrumb = '[\"blog\",\"research\"]'
      releases: ${TABLE}.w3_breadcrumb = '[\"blog\",\"releases\"]'
      analytics: ${TABLE}.w3_breadcrumb = '[\"blog\",\"analytics\"]'
      recruitment: ${TABLE}.w3_breadcrumb = '[\"blog\",\"recruitment\"]'
      inside-the-plow: ${TABLE}.w3_breadcrumb = '[\"blog\",\"inside the plow\"]'
      else: other
  
  - dimension_group: blog_date_published
    type: time
    timeframes: [time, hour, date, week, month]
    sql: ${TABLE}.w3_date_published
  
  - dimension: blog_keywords
    sql: ${TABLE}.w3_keywords
  
  # Time
  
  - dimension: first_touch
    type: time
    timeframes: [time, hour, date, week, month, day_of_week]
    sql: ${TABLE}.first_touch_tstamp
  
  - dimension: device_timestamp
    type: time
    timeframes: [hour_of_day, time_of_day, day_of_week]
    sql: ${TABLE}.min_dvce_tstamp
  
  - dimension: duration
    type: int
    sql: EXTRACT(EPOCH FROM (${TABLE}.max_dvce_tstamp - ${TABLE}.min_dvce_tstamp))
  
  - dimension: duration_tiered
    type: tier
    tiers: [0,1,2,3,4,5,10,30,60,120,300]
    sql: ${duration}
  
  # Engagement
  
  - dimension: minutes_engaged
    type: number
    sql: ${TABLE}.time_engaged_in_minutes
  
  - dimension: minutes_engaged_tiered
    type: tier
    tiers: [0,1,2,3,4,5,10,30,60,120,300]
    sql: ${minutes_engaged}
  
  - dimension: page_view_count
    type: int
    sql: ${TABLE}.page_view_count
  
  - dimension: page_ping_count
    type: int
    sql: ${TABLE}.page_ping_count
  
  - dimension: bounce
    type: yesno
    sql: ${TABLE}.page_view_count = 1 AND ${TABLE}.page_ping_count = 0
  
  # Session index
  
  - dimension: session_id
    type: int
    sql: ${TABLE}.min_domain_sessionidx
  
  - dimension: session_id_difference
    type: int
    sql: ${TABLE}.max_domain_sessionidx - ${TABLE}.min_domain_sessionidx
  
  # Device
  
  # Scrolling
  
  # MEASURES #
  
  - measure: count
    type: count
  