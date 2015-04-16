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

- view: sign_up_basic # Possible extensions: distinct name, email, company count
  derived_table:
    sql: |
      SELECT
        domain_userid,
        MIN(domain_sessionidx) AS domain_sessionidx_at_sign_up,
        MIN(dvce_tstamp) AS dvce_tstamp_at_sign_up,
        SUM(CASE WHEN form_type = 'trial' THEN 1 ELSE 0 END) AS trial_count,
        SUM(CASE WHEN form_type = 'sign_up' THEN 1 ELSE 0 END) AS sign_up_count
      FROM (
        SELECT
          b.domain_userid,
          b.domain_sessionidx,
          b.dvce_tstamp,
          'sign_up' AS form_type,
          a.name,
          a.email,
          a.company,
          a.events_per_month,
          a.service_type
        FROM atomic.com_snowplowanalytics_snowplow_website_signup_form_submitted_1 a
        INNER JOIN atomic.events b
          ON a.root_id = b.event_id
      
        UNION
      
        SELECT
          b.domain_userid,
          b.domain_sessionidx,
          b.dvce_tstamp,
          'trial' AS form_type,
          a.name,
          a.email,
          a.company,
          a.events_per_month,
          NULL AS service_type
        FROM atomic.com_snowplowanalytics_snowplow_website_trial_form_submitted_1 a
          INNER JOIN atomic.events b
        ON a.root_id = b.event_id
      )
      GROUP BY 1

    sql_trigger_value: SELECT MAX(collector_tstamp) FROM ${events.SQL_TABLE_NAME}  # Trigger table generation when new data loaded into atomic.events
    distkey: domain_userid
    sortkeys: [domain_userid]
