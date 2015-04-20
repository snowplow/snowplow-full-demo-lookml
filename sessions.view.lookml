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

- view: sessions
  derived_table:
    sql: |
      SELECT
        b.domain_userid,
        b.domain_sessionidx,
        b.session_start_tstamp,
        b.session_end_tstamp,
        b.dvce_min_tstamp,
        b.dvce_max_tstamp,
        b.event_count,
        b.time_engaged_with_minutes
        
        f.page_urlhost AS first_page_host,
        f.page_urlpath AS first_page_path,
        f.w3_breadcrumb AS first_page_breadcrumb,
        f.w3_genre AS first_page_genre,
        f.w3_author AS first_page_author,
        f.w3_date_published AS first_page_date_published,
        f.w3_keywords AS first_page_keywords,

        s.mkt_source,
        s.mkt_medium,
        s.mkt_term,
        s.mkt_content,
        s.mkt_campaign,
        s.refr_source,
        s.refr_medium,
        s.refr_term,
        s.refr_urlhost,
        s.refr_urlpath,
        
        CASE
          WHEN c.domain_userid IS NOT NULL THEN TRUE
          ELSE FALSE
        END AS user_submitted_form

      FROM ${sessions_basic.SQL_TABLE_NAME} AS b
      LEFT JOIN ${sessions_first_page.SQL_TABLE_NAME} AS f
        ON  b.domain_userid = f.domain_userid
        AND b.domain_sessionidx = f.domain_sessionidx
      LEFT JOIN ${sessions_source.SQL_TABLE_NAME} AS s
        ON  b.domain_userid = s.domain_userid
        AND b.domain_sessionidx = s.domain_sessionidx
      LEFT JOIN ${sign_up.SQL_TABLE_NAME} AS c
        ON  b.domain_userid = c.domain_userid
        AND b.domain_sessionidx = c.domain_sessionidx_at_first_submission
    
    sql_trigger_value: SELECT COUNT(*) FROM ${sessions_source.SQL_TABLE_NAME} # Generate this table after sessions_source
    
    distkey: domain_userid
    sortkeys: [domain_userid, domain_sessionidx]
  
  fields:
  
  # DIMENSIONS #
  
  # Basic dimensions #
  
  - dimension: user_id
    sql: ${TABLE}.domain_userid
    
  - dimension: session_index
    type: int
    sql: ${TABLE}.domain_sessionidx
  
  - dimension: session_id
    sql: ${TABLE}.domain_userid || '-' || ${TABLE}.domain_sessionidx
  
  - dimension: session_index_tier
    type: tier
    tiers: [1,2,3,4,5,10,25,100,1000]
    sql: ${session_index}
  
  - dimension: start
    sql: ${TABLE}.session_start_tstamp
  
  - dimension_group: start
    type: time
    timeframes: [time, hour, date, week, month]
    sql: ${TABLE}.session_start_tstamp
    
  - dimension: end
    sql: ${TABLE}.session_end_tstamp

  - dimension: session_duration_seconds
    type: int
    sql: EXTRACT(EPOCH FROM (${TABLE}.session_end_tstamp - ${TABLE}.session_start_tstamp))

  - dimension: session_duration_seconds_tiered
    type: tier
    tiers: [0,1,5,10,30,60,300,900]
    sql: ${session_duration_seconds}

  - dimension: time_engaged_with_minutes
    sql: ${TABLE}.time_engaged_with_minutes
  
  - dimension: time_engaged_with_minutes_tiered
    type: tier
    tiers: [0,1,5,10,30,60,300,900]
    sql: ${time_engaged_with_minutes}

  # Events per visit and bounces (infered) #

  - dimension: events_during_session
    type: int
    sql: ${TABLE}.event_count
    
  - dimension: events_during_session_tiered
    type: tier
    tiers: [1,2,5,10,25,50,100,1000,10000]
    sql: ${TABLE}.event_count
    
  - dimension: bounce
    type: yesno
    sql: ${TABLE}.event_count = 1
  
  # New vs returning visitor #
  - dimension: new_vs_returning_visitor
    sql_case:
      new: ${TABLE}.domain_sessionidx = 1
      returning: ${TABLE}.domain_sessionidx > 1
      else: unknown
    
  # First page
    
  - dimension: first_page_host
    sql: ${TABLE}.first_page_urlhost
    
  - dimension: first_page_path
    sql: ${TABLE}.first_page_path
    
  - dimension: first_page
    sql: ${TABLE}.first_page_host || ${TABLE}.first_page_path

  - dimension: first_page_breadcrumb
    sql: ${TABLE}.first_page_breadcrumb
  
  - dimension: first_page_genre
    sql: ${TABLE}.first_page_genre
  
  - dimension: first_page_author
    sql: ${TABLE}.first_page_author
  
  - dimension: first_page_date_published
    sql: ${TABLE}.first_page_date_published
  
  - dimension: first_page_keywords
    sql: ${TABLE}.first_page_keywords

  # Referer fields (all acquisition channels)
  
  - dimension: referer_medium
    sql_case:
      email: ${TABLE}.refr_medium = 'email'
      search: ${TABLE}.refr_medium = 'search'
      social: ${TABLE}.refr_medium = 'social'
      other_website: ${TABLE}.refr_medium = 'unknown'
      else: direct
    
  - dimension: referer_source
    sql: ${TABLE}.refr_source
    
  - dimension: referer_term
    sql: ${TABLE}.refr_term
    
  - dimension: referer_url_host
    sql: ${TABLE}.refr_urlhost
  
  - dimension: referer_url_path
    sql: ${TABLE}.refr_urlpath
    
  # Marketing fields (paid acquisition channels)
    
  - dimension: campaign_medium
    sql: ${TABLE}.mkt_medium
  
  - dimension: campaign_source
    sql: ${TABLE}.mkt_source
  
  - dimension: campaign_term
    sql: ${TABLE}.mkt_term
  
  - dimension: campaign_name
    sql: ${TABLE}.mkt_campaign

  - dimension: campaign_content
    sql: ${TABLE}.mkt_content
  
  # Conversion
  
  - dimension: user_submitted_form
    type: yesno
    sql: ${TABLE}.user_submitted_form
  
  # MEASURES #

  - measure: count
    type: count_distinct
    sql: ${session_id}

  - measure: visitors_count
    type: count_distinct
    sql: ${user_id}
    hidden: true
    
  - measure: bounced_sessions_count
    type: count_distinct
    sql: ${session_id}
    filters:
      bounce: yes

  - measure: bounce_rate
    type: number
    decimals: 2
    sql: ${bounced_sessions_count}/NULLIF(${count},0)::REAL
  
  - measure: sessions_from_new_visitors_count
    type: count_distinct
    sql: ${session_id}
    filters:
      session_index: 1

  - measure: sessions_from_returning_visitor_count
    type: number
    sql: ${count} - ${sessions_from_new_visitors_count}

  - measure: new_visitors_count_over_total_visitors_count
    type: number
    decimals: 2
    sql: ${sessions_from_new_visitors_count}/NULLIF(${count},0)::REAL

  - measure: returning_visitors_count_over_total_visitors_count
    type: number
    decimals: 2
    sql: ${sessions_from_returning_visitor_count}/NULLIF(${count},0)::REAL
    
  - measure: event_count
    type: sum
    sql: ${TABLE}.event_count
    
  - measure: events_per_session
    type: number
    decimals: 2
    sql: ${event_count}/NULLIF(${count},0)::REAL
    
  - measure: events_per_visitor
    type: number
    decimals: 2
    sql: ${event_count}/NULLIF(${visitors_count},0)::REAL

  - measure: average_session_duration_seconds
    type: average
    sql: EXTRACT(EPOCH FROM (${end}-${start}))
  
  - measure: average_time_engaged_minutes
    type: average
    sql: ${time_engaged_with_minutes}
  
  # Conversion
  
  - measure: sessions_with_form_submission_count
    type: count_distinct
    sql: ${session_id}
    filters:
      user_submitted_form: yes
  
  - measure: form_conversion_rate
    type: number
    decimals: 2
    sql: ${sessions_with_form_submission_count}/NULLIF(${count},0)::REAL
  
  # Marketing measures

  - measure: campaign_medium_count
    type: count_distinct
    sql: ${campaign_medium}
    
  - measure: campaign_source_count
    type: count_distinct
    sql: ${campaign_source}
    
  - measure: campaign_term_count
    type: count_distinct
    sql: ${campaign_term}
      
  - measure: campaign_count
    type: count_distinct
    sql: ${campaign_name}
  
  # Referer measures

  - measure: referer_medium_count
    type: count_distinct
    sql: ${referer_medium}
    
  - measure: referer_source_count
    type: count_distinct
    sql: ${referer_source}
    
  - measure: referer_term_count
    type: count_distinct
    sql: ${referer_term}
