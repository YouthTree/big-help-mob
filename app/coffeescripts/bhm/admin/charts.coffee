BHM.withNS 'Admin', (ns) ->

  class ns.BaseChart
    
    @getChartType: ->
      throw 'Implement Chart Type'
    
    constructor: (@id) ->
      @parent = $("##{@id}").parents('.statistic')
      @buildInitialOptions()
      
    buildInitialOptions: ->
      @options =
        chart:
          renderTo: @id
          defaultSeriesType: @getChartType()
          backgroundColor: @parent.css('background-color')
          marginTop: 20
        xAxis:
          categories: []
        yAxis:
          min: 0
        legend:
          enabled: true
        title:
          text: ''
        series: []
      
    setSideTitle: (title) ->
      @options.yAxis.title = {text: title}
      
    setCategories: (c) ->
      @options.xAxis.categories = c
    
    setTitle: (t) ->
      @options.title ?= {}
      @options.title.text = t
      
    setDataToolTip: (tooltip) ->
      @options.tooltip = {formatter: tooltip}
      
    addSeries: (name, data) ->
      @options.series.push({
        name: name
        data: data
      })
    
    draw: ->
      @parent.removeClass 'hidden-container'
      $("##{@id}").empty().show()
      @chart = new Highcharts.Chart @options
      
  ns.withNS 'LineChart', (lineNS) ->
  
    class InnerChart extends BHM.Admin.BaseChart
      getChartType: -> 'line'

    lineNS.create = (id, cb) ->
      chart = new InnerChart id
      cb.apply chart if typeof cb is "function"
      chart.draw()
      chart
      
  ns.withNS 'ColumnChart', (columnNS) ->

    class InnerChart extends BHM.Admin.BaseChart
      getChartType: -> 'column'

    columnNS.create = (id, cb) ->
      chart = new InnerChart id
      cb.apply chart if typeof cb is "function"
      chart.draw()
      chart
  
  ns.withNS 'PieChart', (pieNS) ->
    
    class InnerChart extends BHM.Admin.BaseChart
      getChartType: -> 'pie'
      
      emptyFormatter: ->
        @options.plotOptions.pie.dataLabels.formatter = -> ''
      
      buildInitialOptions: ->
        @options =
          chart:
            renderTo: @id
            defaultSeriesType: @getChartType()
            backgroundColor: @parent.css('background-color')

          plotOptions:
            pie:
              dataLabels:
                enabled: true
                formatter: -> @point.name
                style:
                  fontWeight: 'bold'
          xAxis:
            categories: []
          yAxis:
            min: 0
          legend:
            enabled: true
            layout: 'horizontal'
            backgroundColor: '#FFFFFF'
            style:
              marginTop: '10px'
          title:
            text: ''
          series: []
      
      addSeries: (name, labels, data) ->
        seriesData = {
          type: 'pie'
          name: name
          data: []
        }
        labels = labels.slice(0)
        while labels.length > 0
          label = labels.shift()
          item  = data.shift()
          seriesData.data.push [label, item]
        @options.series.push(seriesData)
      
    pieNS.create = (id, cb) ->
      chart = new InnerChart id
      cb.apply chart if typeof cb is "function"
      chart.draw()
      chart