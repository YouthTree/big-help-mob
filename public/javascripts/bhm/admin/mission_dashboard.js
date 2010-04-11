BHM.withNS('Admin.MissionDashboard', function(ns) {
  
  ns.tabsSelector = '#general-participations';
  
  ns.setupTabs = function() {
    $(ns.tabsSelector).tabs();
  };
  
  ns.setup = function() {
    ns.setupTabs();
  };
  
});