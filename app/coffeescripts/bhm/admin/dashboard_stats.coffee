BHM.withNS 'Admin.DashboardStats', (ns) ->
  
  ns.withContainer = (container_id, callback) ->
    return if $("##{container_id}").length < 1
    labels = []
    values = []
    data = $("##{container_id} dl")
    data.find("dt").each ->
      current = $ @
      labels.push current.text()
      values.push current.next('dd').text()
    callback labels, values if typeof callback is "function" and labels.length > 0
    
  
  ns.showUserSignups = ->
    ns.withContainer 'signups-chart', (labels, values) ->
      BHM.Admin.ColumnChart.create 'signups-chart', ->
        @setCategories labels
        @setSideTitle  'Signups per Day'
        @addSeries     'Signups', $.map(values, Number)
        @setDataToolTip -> "#{@y} #{@series.name.toLowerCase()}<br/>on #{@x}."
        
  ns.showUserAges = ->
    ns.withContainer 'ages-chart', (labels, values) ->
      BHM.Admin.LineChart.create 'ages-chart', ->
        @setCategories labels
        @setSideTitle  'No. of People Per Age'
        @addSeries     'People per Age', $.map(values, Number)
        @setDataToolTip -> "#{@y} people<br/>are #{@x} years old."
        
  ns.showUserOrigins = ->
    ns.withContainer 'origins-chart', (labels, values) ->
      BHM.Admin.PieChart.create 'origins-chart', ->
        @setCategories labels
        @addSeries     'No. of People', labels, $.map(values, Number)
        @setDataToolTip -> "#{@y} people<br/>found us via #{@point.name}."
  
  ns.showUserVolunteering = ->
    ns.withContainer 'volunteering-chart', (labels, values) ->
      BHM.Admin.PieChart.create 'volunteering-chart', ->
        @setCategories labels
        @addSeries     'Volunteered in the last year?', labels, $.map(values, Number)
        @setDataToolTip -> "#{@y} people replied:<br/> \"#{@point.name}\"."
  
  ns.showSubscriberVolunteering = ->
    ns.withContainer 'subscriber-volunteering-chart', (labels, values) ->
      BHM.Admin.PieChart.create 'subscriber-volunteering-chart', ->
        @setCategories labels
        @addSeries     'Volunteered in the last year?', labels, $.map(values, Number)
        @setDataToolTip -> "#{@y} subscribers replied:<br/> \"#{@point.name}\"."
        
  ns.showUserGenders = ->
    ns.withContainer 'genders-chart', (labels, values) ->
      BHM.Admin.PieChart.create 'genders-chart', ->
        @setCategories labels
        @addSeries 'No. of People', labels, $.map(values, Number)
        @setDataToolTip -> "#{@y} people<br/>identify as #{@point.name}."
      
  ns.setupOtherOrigins = ->
    $(".other-known-origins-toggle").click ->
      $("#user-origins-list").toggle()
      false
  
  ns.setup = ->
    ns.showUserSignups()
    ns.showUserAges()
    ns.showUserOrigins()
    ns.showUserVolunteering()
    ns.showSubscriberVolunteering()
    ns.showUserGenders()
    ns.setupOtherOrigins()