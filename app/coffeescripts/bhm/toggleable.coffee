BHM.withNS 'Toggleable', (ns) ->
  
  # Selector options.
  ns.linkSelector   = '.toggleable-link'
  ns.parentSelector = '.toggleable'
  # Text options
  ns.showText = '(show)'
  ns.hideText = '(hide)'
  
  ns.makeToggleable = (object) ->
    current    = $ object
    parent     = current.parents ns.parentSelector
    toggleable = parent.find current.dataAttr('toggleable-selector')
    shown      = false
    current.click ->
      if shown
        toggleable.slideUp()
        current.text ns.showText
      else
        toggleable.slideDown()
        current.text ns.hideText
      shown = !shown
      return false
      
  ns.setup = ->
    $(ns.linkSelector).each ->
      ns.makeToggleable this
      