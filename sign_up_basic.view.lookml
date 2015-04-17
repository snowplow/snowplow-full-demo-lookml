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
        MIN(domain_sessionidx) AS domain_sessionidx_at_first_submission,
        MIN(collector_tstamp) AS collector_tstamp_at_first_submission,
        MIN(dvce_tstamp) AS dvce_tstamp_at_first_submission,
        SUM(CASE WHEN sign_up_event THEN 1 ELSE 0 END) AS sign_up_count,
        SUM(CASE WHEN trial_event THEN 1 ELSE 0 END) AS trial_count
      FROM ${events.SQL_TABLE_NAME}
      WHERE sign_up_event IS TRUE OR trial_event IS TRUE
      GROUP BY 1
    
    sql_trigger_value: SELECT COUNT(*) FROM ${events.SQL_TABLE_NAME}  # Trigger after events
    distkey: domain_userid
    sortkeys: [domain_userid]
