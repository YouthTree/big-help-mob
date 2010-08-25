BHM.withNS('Admin.DashboardStats', function(ns) {
  ns.withContainer = function(container_id, callback) {
    var data, labels, values;
    labels = [];
    values = [];
    data = $(("#" + (container_id) + " dl"));
    data.find("dt").each(function() {
      var current;
      current = $(this);
      labels.push(current.text());
      return values.push(current.next('dd').text());
    });
    if (typeof callback === "function" && labels.length > 0) {
      return callback(labels, values);
    }
  };
  ns.showUserSignups = function() {
    return ns.withContainer('signups-chart', function(labels, values) {
      return BHM.Admin.ColumnChart.create('signups-chart', function() {
        this.setCategories(labels);
        this.setSideTitle('Signups per Day');
        this.addSeries('Signups', $.map(values, Number));
        return this.setDataToolTip(function() {
          return "" + (this.y) + " " + (this.series.name.toLowerCase()) + "<br/>on " + (this.x) + ".";
        });
      });
    });
  };
  ns.showUserAges = function() {
    return ns.withContainer('ages-chart', function(labels, values) {
      return BHM.Admin.LineChart.create('ages-chart', function() {
        this.setCategories(labels);
        this.setSideTitle('No. of People Per Age');
        this.addSeries('People per Age', $.map(values, Number));
        return this.setDataToolTip(function() {
          return "" + (this.y) + " people<br/>are " + (this.x) + " years old.";
        });
      });
    });
  };
  ns.showUserOrigins = function() {
    return ns.withContainer('origins-chart', function(labels, values) {
      return BHM.Admin.PieChart.create('origins-chart', function() {
        this.setCategories(labels);
        this.addSeries('No. of People', labels, $.map(values, Number));
        return this.setDataToolTip(function() {
          return "" + (this.y) + " people<br/>found us via " + (this.point.name) + ".";
        });
      });
    });
  };
  ns.setupOtherOrigins = function() {
    return $(".other-known-origins-toggle").click(function() {
      $("#user-origins-list").toggle();
      return false;
    });
  };
  return (ns.setup = function() {
    ns.showUserSignups();
    ns.showUserAges();
    ns.showUserOrigins();
    return ns.setupOtherOrigins();
  });
});