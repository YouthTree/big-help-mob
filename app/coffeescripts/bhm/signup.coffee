BHM.withNS 'Signup', (ns) ->

  ns.originWrapperSelector = '#user_origin_input'
  
  ns.replaceField = ->
    container = $ ns.originWrapperSelector
    container.removeClass('select').addClass('string')
    select = container.find 'select'
    id     = select.attr "id"
    name   = select.attr "name"
    select.remove()
    container.find('label').after $('<input />', name: name, id: id, type: 'text')
    
  ns.shouldReplaceField = ->
    $("#{ns.originWrapperSelector} select").val().toLowerCase() == 'other'
  
  ns.attachEvents = ->
    $("#{ns.originWrapperSelector} select").change =>
      ns.replaceField() if ns.shouldReplaceField()
      
  ns.setup = -> ns.attachEvents()