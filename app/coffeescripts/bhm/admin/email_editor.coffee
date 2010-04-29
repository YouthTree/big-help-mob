BHM.withNS 'Admin.EmailEditor', (ns) ->
  
  ns.participationSelector: '#participations-filter'
  ns.typeSelector:          'select#email_scope_type'
  
  ns.hideParticipationFilter: -> $(ns.participationSelector).hide()
  
  ns.showParticipationFilter: -> $(ns.participationSelector).show()
  
  ns.shouldShowParticipationFilter: ->
    $(ns.typeSelector).val() is "participations"
    
  ns.toggleParticipationFilter: ->
    if ns.shouldShowParticipationFilter()
      ns.showParticipationFilter()
    else
      ns.hideParticipationFilter()
  
  ns.bindEvents: ->
    $(ns.typeSelector).change(-> ns.toggleParticipationFilter()).change()
  
  ns.setup: -> ns.bindEvents()
    