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
        root_id,
        root_tstamp,
        element_id,
        element_classes,
        element_target,
        target_url
      FROM
        atomic.com_snowplowanalytics_snowplow_link_click_1
    
    sql_trigger_value: SELECT COUNT(*) FROM ${visitors.SQL_TABLE_NAME} # Generate this table after visitors
    distkey: root_id
    sortkeys: [root_id]
  
  fields:
  
  # DIMENSIONS #
  
  # Basic dimensions
  
  - dimension: root_id
    primary_key: true
    sql: ${TABLE}.root_id
  
  - dimension: target_url
    sql: ${TABLE}.target_url
  
  - dimension: internal_click
    type: yesno
    sql: ${TABLE}.target_url LIKE 'http://snowplowanalytics.com%'
  
  # MEASURES #
  
  # Basic measures
  
  - measure: count
    type: count