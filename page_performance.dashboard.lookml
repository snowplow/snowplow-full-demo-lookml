- dashboard: page_performance
  title: Page Performance
  layout: grid
  rows:
    - elements: [page_views_per_section]
      height: 500
  #  - elements: [daily_sessions_by_bounce]
  #    height: 500
  #  - elements: [daily_sessions_by_new_repeat]
  #    height: 500
  #  - elements: [sessions_bounced_pie, sessions_new_repeat_pie]
  #    height: 400
  #  - elements: [custom_funnel]
  #    height: 500

  filters:
  
  - name: date
    title: Date
    type: date_filter
    default_value: 90 Days
  
  elements:
  
  #- name: page_views
  #  title: Page Views
  
  - name: page_views_per_section
    title: Page Views per Section
    type: looker_area
    model: snowplow_full_demo
    explore: page_views
    dimensions: [page_views.first_touch_date]
    pivots: [page_views.website_section]
    measures: [page_views.count]
    listen:
      date: page_views.first_touch_date
    #filters:
    #  page_views.first_touch_date: 60 days
    sorts: [page_views.first_touch_date]
    show_null_points: true
    stacking: normal
    show_value_labels: false
    show_view_names: true
    x_axis_gridlines: false
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_gridlines: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    x_axis_scale: auto
    point_style: none
    interpolation: linear
