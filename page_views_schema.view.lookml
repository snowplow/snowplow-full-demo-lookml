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

- view: page_views_schema
  derived_table:
    sql: |
      SELECT
        *
      FROM (
        SELECT -- Select the last schema associated with each page views (using dvce_tstamp)
          a.domain_userid,
          a.domain_sessionidx,
          a.page_urlhost,
          a.page_urlpath,
          
          b.breadcrumb,
          b.genre,
          b.author,
          b.date_published,
          b.keywords,
          
          RANK() OVER (PARTITION BY a.domain_userid, a.domain_sessionidx, a.page_urlhost, a.page_urlpath
            ORDER BY b.breadcrumb, b.genre, b.author, b.date_published, b.keywords) AS rank
        FROM atomic.events AS a
        LEFT JOIN atomic.org_schema_web_page_1 b
          ON a.event_id = b.root_id
        INNER JOIN ${page_views_basic.SQL_TABLE_NAME} AS c
          ON  a.domain_userid = c.domain_userid
          AND a.domain_sessionidx = c.domain_sessionidx
          AND a.page_urlhost = c.page_urlhost
          AND a.page_urlpath = c.page_urlpath
          AND a.dvce_tstamp = c.dvce_max_tstamp
        GROUP BY 1,2,3,4,5,6,7,8,9 -- Aggregate identital rows (that happen to have the same dvce_tstamp)
      )
      WHERE rank = 1 -- If there are different rows with the same dvce_tstamp, rank and pick the first row
    
    sql_trigger_value: SELECT COUNT(*) FROM ${page_views_basic.SQL_TABLE_NAME} # Generate this table after page_views_basic
    distkey: domain_userid
    sortkeys: [domain_userid, domain_sessionidx]
  
  fields:
  
  # DIMENSIONS #
  
  # Basic dimensions
  