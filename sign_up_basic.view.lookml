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

- view: sign_up_basic
  derived_table:
    sql: |
      SELECT
        domain_userid,
        MIN(domain_sessionidx) AS min_domain_sessionidx,
        MIN(dvce_tstamp) AS min_dvce_tstamp,
        SUM(CASE WHEN sign_up_event THEN 1 ELSE 0 END) AS sign_up_count,
        SUM(CASE WHEN trial_event THEN 1 ELSE 0 END) AS trial_count
      FROM ${events.SQL_TABLE_NAME}
      WHERE sign_up_event IS NOT NULL OR trial_event IS NOT NULL
      GROUP BY 1

    sql_trigger_value: SELECT COUNT(*) FROM ${events.SQL_TABLE_NAME}  # Trigger after events
    distkey: domain_userid
    sortkeys: [domain_userid]
