- dashboard: page_performance
  title: Snowplow Demo – Page Performance
  layout: grid
  rows:
    - elements: [total_page_views, engaged_page_views, engaged_visitors, total_time_engaged]
      height: 250
    - elements: [page_views_per_section]
      height: 500
    - elements: [page_views_per_week, time_engaged_per_week]
      height: 500
    - elements: [top_blog_posts, top_pages]
      height: 500
  
  filters:
  
  - name: date
    title: Date
    type: date_filter
    default_value: 90 Days
  
  elements:
  
  - name: total_page_views
    title: Total Page Views
    type: single_value
    model: snowplow_full_demo
    explore: page_views
    measures: [page_views.count]
    listen:
      date: page_views.first_touch_date
    value_format: '[>=1000000] #,##0.0,,"M";[<1000] 0;#,##0.0,"k"'
    font_size: medium
    colors: red
    height: 4
    width: 6
  
  - name: engaged_page_views # time engaged is 1 minute or more
    title: Engaged Page Views
    type: single_value
    model: snowplow_full_demo
    explore: page_views
    measures: [page_views.count]
    listen:
      date: page_views.first_touch_date
    filters:
      page_views.time_engaged: '>=60'
    value_format: '[>=1000000] #,##0.0,,"M";[<1000] 0;#,##0.0,"k"'
    font_size: medium
    height: 4
    width: 6

  - name: engaged_visitors # visitors who had at least once engaged page view
    title: Engaged Visitors
    type: single_value
    model: snowplow_full_demo
    explore: page_views
    measures: [page_views.visitor_count]
    listen:
      date: page_views.first_touch_date
    filters:
      page_views.time_engaged: '>=60'
    value_format: '[>=1000000] #,##0.0,,"M";[<1000] 0;#,##0.0,"k"'
    font_size: medium
    height: 4
    width: 6
  
  - name: total_time_engaged # bounces are removed
    title: Total Time Engaged
    type: single_value
    model: snowplow_full_demo
    explore: page_views
    measures: [page_views.total_time_engaged_in_hours]
    listen:
      date: page_views.first_touch_date
    filters:
      page_views.bounce: no
    value_format: '#,##0"h"'
    font_size: medium
    height: 4
    width: 6
  
  - name: page_views_per_section
    title: Page Views
    type: looker_area
    model: snowplow_full_demo
    explore: page_views
    dimensions: [page_views.first_touch_date]
    pivots: [page_views.website_section]
    measures: [page_views.count]
    listen:
      date: page_views.first_touch_date
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
  
  - name: page_views_per_week
    title: Page Views per Week
    type: looker_area
    model: snowplow_full_demo
    explore: page_views
    dimensions: [page_views.first_touch_week]
    pivots: [page_views.website_section]
    measures: [page_views.count]
    sorts: [page_views.first_touch_week]
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
  
  - name: time_engaged_per_week
    title: Time Engaged per Week
    type: looker_area
    model: snowplow_full_demo
    explore: page_views
    dimensions: [page_views.first_touch_week]
    measures: [page_views.total_time_engaged_in_hours]
    sorts: [page_views.first_touch_week]
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
  
  - name: top_blog_posts
    title: Most Visited Blog Posts
    type: table
    explore: page_views
    dimensions: [page_views.page_title, page_views.page_path]
    measures: [page_views.count, page_views.total_time_engaged]
    listen:
      date: page_views.first_touch_date
    filters:
      page_views.website_section: 'blog'
    sorts: [page_views.count desc]
    limit: 10
    total: true
  
  - name: top_pages
    title: Most Visited Pages
    type: table
    explore: page_views
    dimensions: [page_views.page_title, page_views.page_path]
    measures: [page_views.count, page_views.total_time_engaged]
    listen:
      date: page_views.first_touch_date
    sorts: [page_views.count desc]
    limit: 10
    total: true
