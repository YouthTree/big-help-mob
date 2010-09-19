BHM.withNS('Admin.MissionDashboard', function(ns) {
  ns.tabsSelector = '#general-participations';
  ns.showReportSelector = '#generate-report';
  ns.reportSelector = '#generate-mission-report .inner-report-generator';
  ns.hideReportSelector = '#hide-report-generator-button';
  ns.setupTabs = function() {
    return $(ns.tabsSelector).tabs();
  };
  ns.setupReportGenerator = function() {
    $("" + (ns.showReportSelector) + " a").click(function() {
      $(ns.showReportSelector).slideUp();
      $(ns.reportSelector).slideDown();
      return false;
    });
    return $(ns.hideReportSelector).click(function() {
      $(ns.showReportSelector).slideDown();
      $(ns.reportSelector).slideUp();
      return false;
    });
  };
  return (ns.setup = function() {
    ns.setupTabs();
    return ns.setupReportGenerator();
  });
});