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

- view: events
  derived_table:
    sql: |
      SELECT
        
        -- Events
        
        a.*,
        EXTRACT(EPOCH FROM (collector_tstamp - dvce_tstamp)) AS dvce_collector_time_difference,
        
        -- Link clicks
        
        CASE WHEN b.root_id IS NOT NULL THEN TRUE ELSE FALSE END AS link_click_event,
        
        b.link_element_id,
        b.link_element_classes,
        b.link_element_target,
        b.link_target_url,
        
        -- Form submissions (sign up)
        
        CASE WHEN c.root_id IS NOT NULL THEN TRUE ELSE FALSE END AS sign_up_event,
        
        c.sign_up_name,
        c.sign_up_email,
        c.sign_up_company,
        c.sign_up_events_per_month,
        c.sign_up_service_type,
        
        -- Form submissions (trial)
        
        CASE WHEN d.root_id IS NOT NULL THEN TRUE ELSE FALSE END AS trial_event,
        
        d.trial_name,
        d.trial_email,
        d.trial_company,
        d.trial_events_per_month,
        
        -- W3 content
        
        CASE WHEN e.root_id IS NOT NULL THEN TRUE ELSE FALSE END AS w3_content_event,
        
        e.w3_breadcrumb,
        e.w3_genre,
        e.w3_author,
        e.w3_date_created, -- Not used
        e.w3_date_modified, -- Not used
        e.w3_date_published,
        e.w3_in_language, -- Not relevant
        e.w3_keywords,
        
        -- W3 performance (todo)
        
        CASE WHEN f.root_id IS NOT NULL THEN TRUE ELSE FALSE END AS w3_performance_event
        
      FROM atomic.events a
      
      LEFT JOIN atomic.com_snowplowanalytics_snowplow_link_click_1 b
        ON a.event_id = b.root_id
      LEFT JOIN atomic.com_snowplowanalytics_snowplow_website_signup_form_submitted_1 c
        ON a.event_id = c.root_id
      LEFT JOIN atomic.com_snowplowanalytics_snowplow_website_trial_form_submitted_1 d
        ON a.event_id = d.root_id
      LEFT JOIN atomic.org_schema_web_page_1 e
        ON a.event_id = e.root_id
      LEFT JOIN atomic.org_w3_performance_timing_1 f
        ON a.event_id = f.root_id
      
      WHERE a.domain_sessionidx IS NOT NULL
        AND a.domain_userid IS NOT NULL
        AND a.domain_userid != ''
        AND a.dvce_tstamp IS NOT NULL
        AND a.dvce_tstamp > '2000-01-01' -- Prevent SQL errors
        AND a.dvce_tstamp < '2030-01-01' -- Prevent SQL errors
    
    sql_trigger_value: SELECT COUNT(*) FROM atomic.events # Trigger when atomic.events changes
    distkey: domain_userid
    sortkeys: [domain_userid, domain_sessionidx, collector_tstamp]
