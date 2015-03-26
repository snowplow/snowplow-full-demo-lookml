- connection: snowplow_demo

- include: "*.view.lookml"       # include all the views
- include: "*.dashboard.lookml"  # include all the dashboards

- explore: com_snowplowanalytics_snowplow_link_click_1

- explore: com_snowplowanalytics_snowplow_website_signup_form_submitted_1

- explore: com_snowplowanalytics_snowplow_website_trial_form_submitted_1

- explore: events

- explore: org_schema_web_page_1

- explore: org_w3_performance_timing_1

