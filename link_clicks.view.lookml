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

- view: link_clicks
  derived_table:
    sql: |
      SELECT
        domain_userid,
        domain_sessionidx,
        collector_tstamp,
        link_element_id,
        link_element_classes,
        link_element_target,
        link_target_url,
        REGEXP_SUBSTR(link_target_url, '[^/]+\\.[^/:]+') AS link_target_url_host,
        link_target_url LIKE 'http://snowplowanalytics.com%' AS link_target_is_internal_click,
        link_target_url LIKE '%github.com/snowplow%' AS link_target_is_github_snowplow
      FROM ${events.SQL_TABLE_NAME}
      WHERE link_click_event IS TRUE
  
    sql_trigger_value: SELECT COUNT(*) FROM ${visitors.SQL_TABLE_NAME} # Generate this table after visitors
    distkey: root_id
    sortkeys: [root_id]
  
  fields:
  
  # DIMENSIONS #
  
  # Basic dimensions
  
  - dimension: root_id
    primary_key: true
    sql: ${TABLE}.root_id
  
  - dimension_group: root_timestamp
    type: time
    timeframes: [time, hour, date, week, month]
    sql: ${TABLE}.root_tstamp
  
  - dimension: user_id
    sql: ${TABLE}.domain_userid
  
  - dimension: session_index
    type: int
    sql: ${TABLE}.domain_sessionidx
  
  - dimension: session_id
    sql: ${TABLE}.domain_userid || '-' || ${TABLE}.domain_sessionidx
  
  - dimension: target_url
    sql: ${TABLE}.target_url
  
  - dimension: target_url_host
    sql: ${TABLE}.target_url_host
  
  - dimension: target_is_internal_click
    type: yesno
    sql: ${TABLE}.target_is_internal_click
  
  - dimension: target_is_snowplow_github
    type: yesno
    sql: ${TABLE}.target_is_github_snowplow
  
  # MEASURES #
  
  # Basic measures
  
  - measure: count
    type: count
  