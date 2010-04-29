BHM.withNS 'Admin.MissionDashboard', (ns) ->

  ns.tabsSelector:       '#general-participations'
  ns.showReportSelector: '#generate-report'
  ns.reportSelector:     '#generate-mission-report .inner-report-generator'
  ns.hideReportSelector: '#hide-report-generator-button'
  
  ns.setupTabs: -> $(ns.tabsSelector).tabs()
  
  ns.setupReportGenerator: ->
    $("$ns.showReportSelector a").click ->
      $(ns.showReportSelector).slideUp()
      $(ns.reportSelector).slideDown()
      false
    $(ns.hideReportSelector).click ->
      $(ns.showReportSelector).slideDown()
      $(ns.reportSelector).slideUp()
      false
  
  ns.setup: ->
    ns.setupTabs()
    ns.setupReportGenerator()