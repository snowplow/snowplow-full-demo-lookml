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

- view: sign_up
  derived_table:
    sql: |
      SELECT
      
        a.domain_userid,
        
        a.domain_sessionidx_at_first_submission,
        a.collector_tstamp_at_first_submission,
        a.dvce_tstamp_at_first_submission,
        
        a.sign_up_count,
        a.trial_count,
        
        b.first_plan,
        b.first_events_per_month,
        b.first_service_type
        
      FROM ${sign_up_basic.SQL_TABLE_NAME} a
      LEFT JOIN ${sign_up_details.SQL_TABLE_NAME} b
        ON a.domain_userid = b.domain_userid
    
    sql_trigger_value: SELECT COUNT(*) FROM ${sign_up_details.SQL_TABLE_NAME}  # Trigger after sign_up_details
    
    distkey: domain_userid
    sortkeys: [domain_userid]
  
  fields:
  
  # DIMENSIONS #
  
  # Basic dimensions #
  
  - dimension: user_id
    sql: ${TABLE}.domain_userid
  
  - dimension: session_index_at_first_submission
    type: int
    sql: ${TABLE}.domain_sessionidx_at_first_submission
  
  - dimension: session_index_at_first_submission_tiered
    type: tier
    tiers: [1,2,3,4,5,10,25,100,1000]
    sql: ${session_index_at_first_submission}
  
  - dimension_group: time_at_first_submission
    type: time
    timeframes: [time, hour, date, week, month]
    sql: ${TABLE}.collector_tstamp_at_first_submission
  
  - dimension: number_of_sign_up_submissions
    type: int
    sql: ${TABLE}.sign_up_count
  
  - dimension: number_of_trial_submissions
    type: int
    sql: ${TABLE}.trial_count
  
  - dimension: first_plan
    sql: ${TABLE}.first_plan
  
  - dimension: first_events_per_month
    sql: ${TABLE}.first_events_per_month
  
  - dimension: first_service_type
    sql: ${TABLE}.first_service_type
  
  # MEASURES #
  
  # Basic measures
  
  - measure: count
    type: count
  