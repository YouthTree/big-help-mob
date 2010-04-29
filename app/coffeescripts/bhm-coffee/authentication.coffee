BHM.withNS 'Authentication', (ns) ->
  ns.traditionalAuthenticationSelector: '#traditional-authentication-link'
  ns.rpxnowAuthenticationSelector:      '#rpxnow-authentication-link'
  ns.authMethodSelector:                '#auth-selector-link'
  ns.containerSelector:                 '#authentication-choices'
  ns.traditionalFormSelector:           '#authentication-with-standard-account'
  
  ns.showTraditional: ->
    $(ns.traditionalFormSelector).slideDown()
    $(ns.containerSelector).slideUp()
    
  ns.showSelector: ->
    $(ns.containerSelector).slideDown()
    $(ns.traditionalFormSelector).slideUp()
    
  ns.bindEvents: ->
    $(ns.traditionalAuthenticationSelector).click ->
      ns.showTraditional()
      false
    $(ns.authMethodSelector).click ->
      ns.showSelector()
      false
    
  ns.setup: -> ns.bindEvents()