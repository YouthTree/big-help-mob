BHM.withNS 'Admin.Analytics', (ns) ->

  # API v4
  ns.apiBaseUrl = "http://api.getclicky.com/api/stats/4"

  ns.defaultParams =
    output: "json"
    date:   "last-7-days"
    daily:  1
    
  ns.addSiteParams = (params) ->
    site_id = $.metaAttr "clicky-site-id"
    params.site_id = site_id if site_id?
    site_key = $.metaAttr "clicky-site-key"
    params.sitekey = site_key if site_key?
    params
    
  ns.mergedParams = (newParams) ->
    params = $.extend({}, ns.defaultParams, newParams)
    ns.addSiteParams params
    $.param params
    
  ns.load = ->
  
  ns.showVisitData = (data) ->
    groups = {}
    days   = $.map(data[0].dates, (d) -> d.date).reverse()
    $.each data, ->
      groups[@type] = $.map(@dates, (d) -> Number d.items[0].value).reverse()
    ns.showVisitChart days, groups
      
  formatDays = (days) ->
    $.map days, (day) -> day.split("-").reverse().join("/")
  
  ns.showVisitChart = (days, groups) ->
    BHM.Admin.ColumnChart.create 'visits-chart', ->
      @setCategories formatDays(days)
      @setSideTitle  'Visitors per Day'
      @addSeries     'Visitors',        groups['visitors']
      @addSeries     'Unique Visitors', groups['visitors-unique']
      @setDataToolTip -> "#{@y} #{@series.name.toLowerCase()}<br/>on #{@x}."
  
  ns.getVisitData = ->
    url = "#{ns.apiBaseUrl}?#{ns.mergedParams type: "visitors,visitors-unique"}&json_callback=?"
    $.getJSON url, ns.showVisitData

  ns.setup = ->
    # Load Analytics
    ns.getVisitData()
