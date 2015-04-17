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

- view: sign_up_details
  derived_table:
    sql: |
      SELECT
        *
      FROM (
        SELECT -- Select the first form submission (using dvce_tstamp)
          a.domain_userid,
          CASE WHEN a.trial_event THEN 'trial' ELSE 'sign_up' END AS first_plan,
          CASE WHEN a.trial_event THEN a.trial_events_per_month ELSE a.sign_up_events_per_month END AS first_events_per_month,
          CASE WHEN a.trial_event THEN NULL ELSE a.sign_up_service_type END AS first_service_type,
          RANK() OVER (PARTITION BY a.domain_userid ORDER BY first_plan, first_events_per_month, first_service_type) AS rank
        FROM {events.SQL_TABLE_NAME} AS a
        INNER JOIN ${sign_up_basic.SQL_TABLE_NAME} AS b
          ON  a.domain_userid = b.domain_userid
          AND a.dvce_tstamp = b.dvce_tstamp_at_first_submission
        WHERE a.sign_up_event IS TRUE OR a.trial_event IS TRUE
        GROUP BY 1,2,3,4 -- Aggregate identital rows (that happen to have the same dvce_tstamp)
      )
      WHERE rank = 1 -- If there are different rows with the same dvce_tstamp, rank and pick the first row
    
    sql_trigger_value: SELECT COUNT(*) FROM ${sign_up_basic.SQL_TABLE_NAME}  # Trigger after sign_up_basic
    distkey: domain_userid
    sortkeys: [domain_userid]
