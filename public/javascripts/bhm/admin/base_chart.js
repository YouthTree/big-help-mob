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
  return ns.BaseChart;
});