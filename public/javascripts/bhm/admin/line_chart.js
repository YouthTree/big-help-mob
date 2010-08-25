var __extends = function(child, parent) {
    var ctor = function(){};
    ctor.prototype = parent.prototype;
    child.prototype = new ctor();
    child.prototype.constructor = child;
    if (typeof parent.extended === "function") parent.extended(child);
    child.__superClass__ = parent.prototype;
  };
BHM.withNS('Admin.LineChart', function(ns) {
  var InnerChart;
  InnerChart = function() {
    return BHM.Admin.BaseChart.apply(this, arguments);
  };
  __extends(InnerChart, BHM.Admin.BaseChart);
  InnerChart.prototype.getChartType = function() {
    return 'line';
  };
  return (ns.create = function(id, cb) {
    var chart;
    chart = new InnerChart(id);
    if (typeof cb === "function") {
      cb.apply(chart);
    }
    chart.draw();
    return chart;
  });
});