BHM.withNS 'Admin.NestedForm', (ns) ->

  ns.fieldsetSelector = 'fieldset'
  ns.removeSelector   = 'a.remove-link'
  ns.addSelector      = 'a.add-link'
  ns.template         = ''

  ns.attachEvents = ->
    $(ns.addSelector).click ->
      ns.addItem()
      false
    $(ns.fieldsetSelector).each -> ns.attachEventOn $(this)

  ns.attachEventsOn = (fieldset) ->
    fs.find(ns.removeSelector).click ->
      ns.removeItem @
      false

  ns.addItem = ->
    inner = ns.template.replace /NESTED_IDX/g, Numbe(new Date())
    $("#{ns.fieldsetSelector}:last").after inner
    ns.attachEventOn $("#{ns.fieldsetSelector}:last")

  ns.removeItem = (link) ->
    link = $ link
    link.parents(ns.fieldsetSelector).find("input[type=hidden]").val('1').end().hide()

  ns.setup = -> ns.attachEvents()