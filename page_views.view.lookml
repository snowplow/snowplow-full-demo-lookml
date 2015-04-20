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
  derived_table:
    sql: |
      SELECT
        b.domain_userid,
        b.domain_sessionidx,
        b.page_urlhost,
        b.page_urlpath,
        b.first_touch_tstamp,
        b.last_touch_tstamp,
        b.dvce_min_tstamp,
        b.dvce_max_tstamp,
        b.event_count,
        b.page_view_count,
        b.page_ping_count,
        b.time_engaged_with_minutes,
        
        s.page_title,
        
        s.w3_breadcrumb AS breadcrumb,
        s.w3_genre AS genre,
        s.w3_author AS author,
        s.w3_date_published AS date_published,
        s.w3_keywords AS keywords
        
      FROM ${page_views_basic.SQL_TABLE_NAME} b
      LEFT JOIN ${page_views_schema.SQL_TABLE_NAME} AS s
        ON  b.domain_userid = s.domain_userid
        AND b.domain_sessionidx = s.domain_sessionidx
        AND b.page_urlhost = s.page_urlhost
        AND b.page_urlpath = s.page_urlpath
      WHERE b.page_urlhost NOT LIKE 'localhost%'
    
    sql_trigger_value: SELECT COUNT(*) FROM ${page_views_schema.SQL_TABLE_NAME} # Generate this table after page_views_schema
    distkey: domain_userid
    sortkeys: [domain_userid, domain_sessionidx, first_touch_tstamp]
  
  fields:
  
  # DIMENSIONS # 
  
  # Session-related dimensions
  
  - dimension: user_id
    sql: ${TABLE}.domain_userid
  
  - dimension: session_index
    type: int
    sql: ${TABLE}.domain_sessionidx
  
  - dimension: session_id
    sql: ${user_id} || '-' || ${session_index}
  
  - dimension: session_index_tier
    type: tier
    tiers: [1,2,3,4,5,10,25,100,1000]
    sql: ${session_index}
  
  # Page-related dimensions
  
  - dimension: page_host
    sql: ${TABLE}.page_urlhost
  
  - dimension: page_path
    sql: ${TABLE}.page_urlpath
  
  - dimension: page
    sql: ${page_host} || ${page_path}
  
  - dimension: page_title
    sql: ${TABLE}.page_title
  
  - dimension: page_breadcrumb
    sql: ${TABLE}.breadcrumb
  
  - dimension: page_genre
    sql: ${TABLE}.genre
  
  - dimension: page_author
    sql: ${TABLE}.author
  
  - dimension_group: page_date_published
    type: time
    timeframes: [time, hour, date, week, month]
    sql: ${TABLE}.date_published
  
  - dimension: page_keywords
    sql: ${TABLE}.keywords

  # Time-related dimensions
  
  - dimension: days_since_publishing
    type: int
    sql: EXTRACT(DAYS FROM (${TABLE}.first_touch_tstamp - ${TABLE}.date_published))
  
  - dimension: weeks_since_publishing
    type: int
    sql: ROUND(${days_since_publishing}/7)
  
  # Engagement-related dimensions
  
  - dimension_group: first_touch
    type: time
    timeframes: [time, hour, date, week, month]
    sql: ${TABLE}.first_touch_tstamp
  
  - dimension_group: last_touch
    type: time
    timeframes: [time, hour, date, week, month]
    sql: ${TABLE}.last_touch_tstamp
  
  - dimension: seconds_between_first_and_last_touch
    type: int
    sql: EXTRACT(EPOCH FROM (${TABLE}.last_touch_tstamp - ${TABLE}.first_touch_tstamp))
  
  - dimension: seconds_between_first_and_last_touch_tiered
    type: tier
    tiers: [0,1,5,10,30,60,300,900]
    sql: ${seconds_between_first_and_last_touch}
  
  - dimension: number_of_events
    type: int
    sql: ${TABLE}.event_count
  
  - dimension: number_of_page_views
    type: int
    sql: ${TABLE}.page_view_count
  
  - dimension: number_of_page_pings
    type: int
    sql: ${TABLE}.page_ping_count
  
  - dimension: minutes_engaged
    type: number
    sql: ${TABLE}.time_engaged_with_minutes
  
  - dimension: minutes_engaged_tiered
    type: tier
    tiers: [0,1,2,3,4,5,10,30,60,120,300]
    sql: ${minutes_engaged}
  
  # MEASURES #
  
  # Basic counts
  
  - measure: row_count
    type: count
  
  - measure: session_count
    type: count_distinct
    sql: ${session_id}
  
  - measure: visitor_count
    type: count_distinct
    sql: ${user_id}
  
  - measure: page_count
    type: count_distinct
    sql: ${page}
    drill_fields: 
    - page
    - detail*
  
  # More counts
  
  - measure: total_number_of_events
    type: sum
    sql: ${number_of_events}
  
  - measure: total_number_of_page_views
    type: sum
    sql: ${number_of_page_views}
  
  - measure: total_number_of_page_pings
    type: sum
    sql: ${number_of_page_pings}
  
  - measure: total_minutes_engaged
    type: sum
    sql: ${minutes_engaged}
  
  # Test
  
  - measure: unique_page_views
    type: count_distinct
    sql: ${user_id} || '-' || ${page} # unique combinations
  
  - measure: cumulative_unique_page_views
    type: running_total
    sql: ${unique_page_views}
  
  - measure: unique_page_views_per_post
    type: number
    decimals: 2
    sql: ${unique_page_views}/NULLIF(${page_count},0)::REAL
  
  - measure: total_minutes_engaged_per_post
    type: number
    decimals: 2
    sql: ${total_minutes_engaged}/NULLIF(${page_count},0)::REAL
  
  # Averages
  
  - measure: average_seconds_between_first_and_last_touch
    type: average
    sql: ${seconds_between_first_and_last_touch}
  
  - measure: average_minutes_engaged
    type: average
    sql: ${minutes_engaged}
    value_format: '#.00'
  
  # DRILL FIELDS #

  sets:
  
    detail:
      - row_count