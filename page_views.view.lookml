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
        s.breadcrumb,
        s.genre,
        s.author,
        s.date_published,
        s.keywords
      FROM ${page_views_basic.SQL_TABLE_NAME} b
      LEFT JOIN ${page_views_schema.SQL_TABLE_NAME} AS s
        ON  b.domain_userid = s.domain_userid
        AND b.domain_sessionidx = s.domain_sessionidx
        AND b.page_urlhost = s.page_urlhost
        AND b.page_urlpath = s.page_urlpath
    
    sql_trigger_value: SELECT COUNT(*) FROM ${page_views_schema.SQL_TABLE_NAME} # Generate this table after page_views_schema
    distkey: domain_userid
    sortkeys: [domain_userid, domain_sessionidx, first_touch_tstamp]
  
  fields:
  
  # DIMENSIONS # 
  
  # Basic dimensions