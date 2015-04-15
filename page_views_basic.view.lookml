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

- view: page_views_basic
  derived_table:
    sql: |
      SELECT
        domain_userid,
        domain_sessionidx,
        page_urlhost,
        page_urlpath,
        MIN(collector_tstamp) AS first_touch_tstamp,
        MAX(collector_tstamp) AS last_touch_tstamp,
        MIN(dvce_tstamp) AS dvce_min_tstamp,
        MAX(dvce_tstamp) AS dvce_max_tstamp,
        COUNT(*) AS event_count,
        SUM(CASE WHEN event = 'page_view' THEN 1 ELSE 0 END) AS page_view_count,
        SUM(CASE WHEN event = 'page_ping' THEN 1 ELSE 0 END) AS page_ping_count,
        COUNT(DISTINCT(FLOOR(EXTRACT (EPOCH FROM dvce_tstamp)/30)))/2::FLOAT AS time_engaged_with_minutes
      FROM
        atomic.events
      WHERE page_urlhost IS NOT NULL
        AND page_urlpath IS NOT NULL
        AND domain_sessionidx IS NOT NULL
        AND domain_userid IS NOT NULL
        AND domain_userid != ''
        AND dvce_tstamp IS NOT NULL
        AND dvce_tstamp > '2000-01-01' -- Prevent SQL errors
        AND dvce_tstamp < '2030-01-01' -- Prevent SQL errors
      GROUP BY 1,2,3,4
    
    sql_trigger_value: SELECT COUNT(*) FROM ${link_clicks.SQL_TABLE_NAME} # Generate this table after link_clicks
    distkey: domain_userid
    sortkeys: [domain_userid, domain_sessionidx, first_touch_tstamp]
