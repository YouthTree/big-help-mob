BHM.withNS('Admin.MissionDashboard', function(ns) {
  
  ns.tabsSelector       = '#general-participations';
  ns.showReportSelector = '#generate-report';
  ns.reportSelector     = '#generate-mission-report .inner-report-generator'
  ns.hideReportSelector = '#hide-report-generator-button'
  
  ns.setupTabs = function() {
    $(ns.tabsSelector).tabs();
  };
  
  ns.setupReportGenerator = function() {
    $(ns.showReportSelector + ' a').click(function() {
      $(ns.showReportSelector).slideUp();
      $(ns.reportSelector).slideDown();
      return false;
    });
    $(ns.hideReportSelector).click(function() {
      $(ns.reportSelector).slideUp();
      $(ns.showReportSelector).slideDown();
      return false;
    });
  };

  ns.setup = function() {
    ns.setupTabs();
    ns.setupReportGenerator();
  };
  
});