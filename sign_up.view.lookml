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

- view: sign_up
  derived_table:
    sql: |
      SELECT
        a.domain_userid,
        a.min_domain_sessionidx,
        a.min_dvce_tstamp,
        a.sign_up_count,
        a.trial_count,
        b.first_plan,
        b.first_events_per_month,
        b.first_service_type
      FROM ${sign_up_basic.SQL_TABLE_NAME} a
      LEFT JOIN ${sign_up_basic.SQL_TABLE_NAME} b
        ON a.domain_userid = b.domain_userid
    
    sql_trigger_value: SELECT COUNT(*) FROM ${sign_up_details.SQL_TABLE_NAME}  # Trigger after sign_up_details
    distkey: domain_userid
    sortkeys: [domain_userid]
