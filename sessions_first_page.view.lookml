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

- view: sessions_first_page
  derived_table:
    sql: |
      SELECT
        *
      FROM (
        SELECT -- Select the first page (using dvce_tstamp)
        
          a.domain_userid,
          a.domain_sessionidx,
          
          a.page_urlhost,
          a.page_urlpath,
          
          a.w3_breadcrumb,
          a.w3_genre,
          a.w3_author,
          a.w3_date_published,
          a.w3_keywords,
          
          RANK() OVER (PARTITION BY a.domain_userid, a.domain_sessionidx ORDER BY a.page_urlhost, a.page_urlpath,
            a.w3_breadcrumb, a.w3_genre, a.w3_author, a.w3_date_published, a.w3_keywords) AS rank
          
        FROM ${events.SQL_TABLE_NAME} AS a
        INNER JOIN ${sessions_basic.SQL_TABLE_NAME} AS b
          ON  a.domain_userid = b.domain_userid
          AND a.domain_sessionidx = b.domain_sessionidx
          AND a.dvce_tstamp = b.dvce_min_tstamp
        GROUP BY 1,2,3,4 -- Aggregate identital rows (that happen to have the same dvce_tstamp)
      )
      WHERE rank = 1 -- If there are different rows with the same dvce_tstamp, rank and pick the first row

    sql_trigger_value: SELECT COUNT(*) FROM ${sessions_geo.SQL_TABLE_NAME} # Generate this table after sessions_geo
    distkey: domain_userid
    sortkeys: [domain_userid, domain_sessionidx]
