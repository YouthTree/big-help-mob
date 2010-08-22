BHM.withNS 'Admin.PickupEditor', (ns) ->

  ns.fieldsetSelector = '.pickup-input'
  ns.removeSelector   = 'a.remove-pickup-link'
  ns.addSelector      = 'a.add-pickup-link'
  ns.template         = ''
  
  ns.attachEvents = ->
    $(ns.addSelector).click ->
      ns.addPickup()
      false
    $(ns.fieldsetSelector).each -> ns.attachEventOn $(this)
    
  ns.attachEventOn = (fs) ->
    fs.find(ns.removeSelector).click ->
      ns.deletePickup @
      false
  
  ns.addPickup = ->
    inner = ns.template.replace /PICKUP_IDX/g, Number(new Date())
    $("#{ns.fieldsetSelector}:last").after inner
    ns.attachEventOn $("#{ns.fieldsetSelector}:last")
  
  ns.deletePickup = (link) ->
    link = $ link
    link.parents(ns.fieldsetSelector).find("input[type=hidden]").val('1').end().hide()
  
  ns.setup = -> ns.attachEvents()