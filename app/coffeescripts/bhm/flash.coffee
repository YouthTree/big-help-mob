BHM.withNS 'Flash', (ns) ->
  
  ns.parentSelector: '#flash-messages'
  ns.insideSelector: 'p.flash'
  ns.hideFlash:      5000
  
  ns.hideAllFlash: ->
    $("$ns.parentSelector $ns.insideSelector").each -> ns.hideFlash @
  
  ns.hideFlash: (e) ->
    $(e).slideUp -> $(@).remove()
    
  ns.setupTimers: ->
    setTimeout ns.hideAllFlash, ns.hideTimeout
    
  ns.attachClickEvents: ->
    $("$ns.parentSelector $ns.insideSelector").click ->
      ns.hideFlash(@)
      false
    
  ns.setup: ->
    return if $(ns.parentSelector).size() < 1
    ns.setupTimers()
    ns.attachClickEvents()