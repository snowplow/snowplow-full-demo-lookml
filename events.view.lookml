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

- view: events
  derived_table:
    sql: |
      SELECT
        
        -- Events
        
        a.*,
        EXTRACT(EPOCH FROM (collector_tstamp - dvce_tstamp)) AS dvce_collector_time_difference,
        
        -- Link clicks
        
        CASE WHEN b.root_id IS NOT NULL THEN TRUE ELSE FALSE END AS link_click_event,
        
        b.link_element_id,
        b.link_element_classes,
        b.link_element_target,
        b.link_target_url,
        
        -- Form submissions (sign up)
        
        CASE WHEN c.root_id IS NOT NULL THEN TRUE ELSE FALSE END AS sign_up_event,
        
        c.sign_up_name,
        c.sign_up_email,
        c.sign_up_company,
        c.sign_up_events_per_month,
        c.sign_up_service_type,
        
        -- Form submissions (trial)
        
        CASE WHEN d.root_id IS NOT NULL THEN TRUE ELSE FALSE END AS trial_event,
        
        d.trial_name,
        d.trial_email,
        d.trial_company,
        d.trial_events_per_month,
        
        -- W3 content
        
        CASE WHEN e.root_id IS NOT NULL THEN TRUE ELSE FALSE END AS w3_content_event,
        
        e.w3_breadcrumb,
        e.w3_genre,
        e.w3_author,
        e.w3_date_created, -- Not used
        e.w3_date_modified, -- Not used
        e.w3_date_published,
        e.w3_in_language, -- Not relevant
        e.w3_keywords,
        
        -- W3 performance (todo)
        
        CASE WHEN f.root_id IS NOT NULL THEN TRUE ELSE FALSE END AS w3_performance_event
        
      FROM atomic.events a
      
      LEFT JOIN atomic.com_snowplowanalytics_snowplow_link_click_1 b
        ON a.event_id = b.root_id
      LEFT JOIN atomic.com_snowplowanalytics_snowplow_website_signup_form_submitted_1 c
        ON a.event_id = c.root_id
      LEFT JOIN atomic.com_snowplowanalytics_snowplow_website_trial_form_submitted_1 d
        ON a.event_id = d.root_id
      LEFT JOIN atomic.org_schema_web_page_1 e
        ON a.event_id = e.root_id
      LEFT JOIN atomic.org_w3_performance_timing_1 f
        ON a.event_id = f.root_id
      
      WHERE a.domain_sessionidx IS NOT NULL
        AND a.domain_userid IS NOT NULL
        AND a.domain_userid != ''
        AND a.dvce_tstamp IS NOT NULL
        AND a.dvce_tstamp > '2000-01-01' -- Prevent SQL errors
        AND a.dvce_tstamp < '2030-01-01' -- Prevent SQL errors
    
    sql_trigger_value: SELECT COUNT(*) FROM atomic.events # Trigger when atomic.events changes
    distkey: domain_userid
    sortkeys: [domain_userid, domain_sessionidx, collector_tstamp]
  
  fields:
  
  # DIMENSIONS #
  
  - dimension: event_id
    primary_key: true
    sql: ${TABLE}.event_id
  
  - dimension: event_type
    sql: ${TABLE}.event

  - dimension: session_index
    type: number
    sql: ${TABLE}.domain_sessionidx

  - dimension: user_id
    sql: ${TABLE}.domain_userid

  - dimension: session_id
    sql: ${TABLE}.domain_userid || '-' || ${TABLE}.domain_sessionidx

  # Timestamp dimensions
  
  - dimension: collector_timestamp
    sql: ${TABLE}.collector_tstamp
  
  - dimension_group: collector_timestamp
    type: time
    timeframes: [time, hour, date, week, month]
    sql: ${TABLE}.collector_tstamp
  
  - dimension: device_timestamp
    sql: ${TABLE}.dvce_tstamp
    hidden: true
  
  - dimension_group: device_timestamp
    type: time
    timeframes: [time, hour, date, week, month]
    sql: ${TABLE}.dvce_tstamp
    hidden: true
  
  - dimension: device_collector_time_difference
    type: int
    sql: ${TABLE}.dvce_collector_time_difference
  
  - dimension: device_collector_time_difference_tiered
    type: tier
    tiers: [-1000000,-100000,-10000,-1000,-100,-10,-1,0,1,10,100,1000,10000,100000,1000000]
    sql: ${device_collector_time_difference}
  
  # Page dimensions

  - dimension: page_title
    sql: ${TABLE}.page_title

  - dimension: page_url_scheme
    sql: ${TABLE}.page_urlscheme

  - dimension: page_url_host
    sql: ${TABLE}.page_urlhost
      
  - dimension: page_url_path
    sql: ${TABLE}.page_urlpath

  - dimension: page_url_port
    type: int
    sql: ${TABLE}.page_urlport
    hidden: true

  - dimension: page_url_query
    sql: ${TABLE}.page_urlquery
    hidden: true

  - dimension: page_url_fragment
    sql: ${TABLE}.page_urlfragment
    hidden: true
    
  - dimension: refr_medium
    sql: ${TABLE}.refr_medium
    
  - dimension: first_event_in_session
    type: yesno
    sql: ${TABLE}.refr_medium != 'internal'
    
  - dimension: first_event_for_visitor
    type: yesno
    sql: ${TABLE}.refr_medium != 'internal' AND ${TABLE}.domain_sessionidx = 1
    
  - dimension: refr_source
    sql: ${TABLE}.refr_source
    
  - dimension: refr_term
    sql: ${TABLE}.refr_term
    
  - dimension: refr_url_host
    sql: ${TABLE}.refr_urlhost
    
  - dimension: refr_url_path
    sql: ${TABLE}.refr_urlpath

  - dimension: x_offset
    type: int
    sql: ${TABLE}.pp_xoffset_max

  - dimension: pp_xoffset_min
    type: int
    sql: ${TABLE}.pp_xoffset_min
    hidden: true

  - dimension: y_offset
    type: int
    sql: ${TABLE}.pp_yoffset_max

  - dimension: pp_yoffset_min
    type: int
    sql: ${TABLE}.pp_yoffset_min
    hidden: true

  - dimension: structured_event_action
    sql: ${TABLE}.se_action

  - dimension: structured_event_category
    sql: ${TABLE}.se_category

  - dimension: structured_event_label
    sql: ${TABLE}.se_label

  - dimension: structured_event_property
    sql: ${TABLE}.se_property

  - dimension: structured_event_value
    type: number
    sql: ${TABLE}.se_value
    
  - dimension: user_agent
    sql: ${TABLE}.useragent
    hidden: true
    
  - dimension: page_height
    type: int
    sql: ${TABLE}.doc_height
    
  - dimension: page_width
    type: int
    sql: ${TABLE}.doc_width
  
  # MEASURES #

  - measure: count
    type: count
    drill_fields: event_detail*

  - measure: page_pings_count
    type: count
    drill_fields: event_detail*
    filters:
      event_type: page_ping
      
  - measure: page_views_count
    type: count
    drill_fields: page_views_detail*
    filters:
      event_type: page_view

  - measure: distinct_pages_viewed_count
    type: count_distinct
    drill_fields: page_views_detail*
    sql: ${page_url_path}
    
  - measure: sessions_count
    type: count_distinct
    sql: ${session_id}
    drill_fields: detail*
    
  - measure: page_pings_per_session
    type: number
    decimals: 2
    sql: NULLIF(${page_pings_count},0)/NULLIF(${sessions_count},0)::REAL

  - measure: page_pings_per_visitor
    type: number
    decimals: 2
    sql: NULLIF(${page_pings_count},0)/NULLIF(${visitors_count},0)::REAL

  - measure: visitors_count
    type: count_distinct
    sql: ${user_id}
    drill_fields: visitors_detail
    hidden: true  # Not to be shown in the UI (in UI only show visitors count for visitors table)
    
  - measure: events_per_session
    type: number
    decimals: 2
    sql: ${count}/NULLIF(${sessions_count},0)::REAL
    
  - measure: events_per_visitor
    type: number
    decimals: 2
    sql: ${count}/NULLIF(${visitors_count},0)::REAL

  - measure: page_views_per_sessions
    type: number
    decimals: 2
    sql: ${page_views_count}/NULLIF(${sessions_count},0)::REAL
    
  - measure: page_views_per_visitor
    type: number
    decimals: 2
    sql: ${page_views_count}/NULLIF(${visitors_count},0)::REAL
  
  - measure: landing_page_views_count
    type: count
    filters:
      event_type: page_view
      first_event_in_session: yes
    
  - measure: internal_page_views_count
    type: count
    filters: 
      event_type: page_view
      first_event_in_session: no
      
  - measure: approx_user_usage_in_minutes
    type: number
    decimals: 2
    sql: APPROXIMATE COUNT( DISTINCT CONCAT(FLOOR(EXTRACT (EPOCH FROM ${TABLE}.collector_tstamp)/10), ${TABLE}.domain_userid) ) /6
    
  - measure: approx_usage_per_visitor_in_seconds
    type: number
    decimals: 2
    sql: ${approx_user_usage_in_minutes}/NULLIF(${visitors_count}, 0)::REAL
    
  - measure: approx_usage_per_visit_in_seconds
    type: number
    decimals: 2
    sql: ${approx_user_usage_in_minutes}/NULLIF(${sessions_count}, 0)::REAL
  
  # DRILL FIELDS#

  sets:
    event_detail:
      - session_index
      - event_type
      - device_timestamp
      - page_url_host
      - page_url_path
    
    page_views_detail:
      - page_url_host
      - page_url_path
      - device_timestamp
    
    session_detail:
      - user_id
      - session_index
      - sessions.referer_url_host
      - sessions.referer_url_path
      - sessions.landing_page
      - sessions.session_duration_seconds
      - count
    
    visitor_detail:
      - user_id
      - visitors.first_touch
      - visitor.referer_url_host
      - visitors.referer_url_path
      - visitors.last_touch
      - visitors.number_of_sessions
      - visitors.event_stream
