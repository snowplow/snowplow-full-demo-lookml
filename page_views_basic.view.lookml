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
        a.domain_userid,
        a.domain_sessionidx,
        a.page_urlhost,
        a.page_urlpath,
        
        b.breadcrumb,
        b.genre,
        b.author,
        b.date_published,
        b.keywords,
        
        MIN(a.collector_tstamp) AS first_touch_tstamp,
        MAX(a.collector_tstamp) AS last_touch_tstamp,

        COUNT(*) AS event_count,
        SUM(CASE WHEN a.event = 'page_view' THEN 1 ELSE 0 END) AS page_view_count,
        SUM(CASE WHEN a.event = 'page_ping' THEN 1 ELSE 0 END) AS page_ping_count,
        COUNT(DISTINCT(FLOOR(EXTRACT (EPOCH FROM a.dvce_tstamp)/30)))/2::FLOAT AS time_engaged_with_minutes
        
      FROM
        atomic.events a
      LEFT JOIN
        atomic.org_schema_web_page_1 b ON a.event_id = b.root_id
      GROUP BY 1,2,3,4,5,6,7,8,9
  
    sql_trigger_value: SELECT COUNT(*) FROM ${visitors.SQL_TABLE_NAME} # Generate this table after visitors
    distkey: domain_userid
    sortkeys: [domain_userid, domain_sessionidx, first_touch_tstamp]
  
  fields:
  
  # DIMENSIONS #
  
  # Basic dimensions
