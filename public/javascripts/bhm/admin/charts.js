var __extends = function(child, parent) {
    var ctor = function(){};
    ctor.prototype = parent.prototype;
    child.prototype = new ctor();
    child.prototype.constructor = child;
    if (typeof parent.extended === "function") parent.extended(child);
    child.__superClass__ = parent.prototype;
  };
BHM.withNS('Admin', function(ns) {
  ns.BaseChart = function(_a) {
    this.id = _a;
    this.parent = $(("#" + (this.id))).parents('.statistic');
    this.buildInitialOptions();
    return this;
  };
  ns.BaseChart.getChartType = function() {
    throw 'Implement Chart Type';
  };
  ns.BaseChart.prototype.buildInitialOptions = function() {
    return (this.options = {
      chart: {
        renderTo: this.id,
        defaultSeriesType: this.getChartType(),
        backgroundColor: this.parent.css('background-color'),
        marginTop: 20
      },
      xAxis: {
        categories: []
      },
      yAxis: {
        min: 0
      },
      legend: {
        enabled: true
      },
      title: {
        text: ''
      },
      series: []
    });
  };
  ns.BaseChart.prototype.setSideTitle = function(title) {
    return (this.options.yAxis.title = {
      text: title
    });
  };
  ns.BaseChart.prototype.setCategories = function(c) {
    return (this.options.xAxis.categories = c);
  };
  ns.BaseChart.prototype.setTitle = function(t) {
    this.options.title = (typeof this.options.title !== "undefined" && this.options.title !== null) ? this.options.title : {};
    return (this.options.title.text = t);
  };
  ns.BaseChart.prototype.setDataToolTip = function(tooltip) {
    return (this.options.tooltip = {
      formatter: tooltip
    });
  };
  ns.BaseChart.prototype.addSeries = function(name, data) {
    return this.options.series.push({
      name: name,
      data: data
    });
  };
  ns.BaseChart.prototype.draw = function() {
    this.parent.removeClass('hidden-container');
    $(("#" + (this.id))).empty().show();
    return new Highcharts.Chart(this.options);
  };
  ns.withNS('LineChart', function(lineNS) {
    var InnerChart;
    InnerChart = function() {
      return BHM.Admin.BaseChart.apply(this, arguments);
    };
    __extends(InnerChart, BHM.Admin.BaseChart);
    InnerChart.prototype.getChartType = function() {
      return 'line';
    };
    return (lineNS.create = function(id, cb) {
      var chart;
      chart = new InnerChart(id);
      if (typeof cb === "function") {
        cb.apply(chart);
      }
      chart.draw();
      return chart;
    });
  });
  ns.withNS('ColumnChart', function(columnNS) {
    var InnerChart;
    InnerChart = function() {
      return BHM.Admin.BaseChart.apply(this, arguments);
    };
    __extends(InnerChart, BHM.Admin.BaseChart);
    InnerChart.prototype.getChartType = function() {
      return 'column';
    };
    return (columnNS.create = function(id, cb) {
      var chart;
      chart = new InnerChart(id);
      if (typeof cb === "function") {
        cb.apply(chart);
      }
      chart.draw();
      return chart;
    });
  });
  return ns.withNS('PieChart', function(pieNS) {
    var InnerChart;
    InnerChart = function() {
      return BHM.Admin.BaseChart.apply(this, arguments);
    };
    __extends(InnerChart, BHM.Admin.BaseChart);
    InnerChart.prototype.getChartType = function() {
      return 'pie';
    };
    InnerChart.prototype.buildInitialOptions = function() {
      return (this.options = {
        chart: {
          renderTo: this.id,
          defaultSeriesType: this.getChartType(),
          backgroundColor: this.parent.css('background-color'),
          marginTop: 20,
          marginBottom: 75
        },
        plotOptions: {
          pie: {
            dataLabels: {
              enabled: true,
              formatter: function() {
                return this.point.name;
              },
              style: {
                textColor: '#FFFFFF',
                fontWeight: 'bold'
              }
            }
          }
        },
        xAxis: {
          categories: []
        },
        yAxis: {
          min: 0
        },
        legend: {
          enabled: true,
          layout: 'horizontal',
          backgroundColor: '#FFFFFF',
          style: {
            marginTop: '10px'
          }
        },
        title: {
          text: ''
        },
        series: []
      });
    };
    InnerChart.prototype.addSeries = function(name, labels, data) {
      var item, label, seriesData;
      seriesData = {
        type: 'pie',
        name: name,
        data: []
      };
      labels = labels.slice(0);
      while (labels.length > 0) {
        label = labels.shift();
        item = data.shift();
        seriesData.data.push([label, item]);
      }
      return this.options.series.push(seriesData);
    };
    return (pieNS.create = function(id, cb) {
      var chart;
      chart = new InnerChart(id);
      if (typeof cb === "function") {
        cb.apply(chart);
      }
      chart.draw();
      return chart;
    });
  });
});