BHM.withNS 'Mission', (ns) ->

  ns.selector: '#pickups-listing li abbr'

  ns.setup: ->
    $(ns.selector).tipsy {
      title:   -> this.getAttribute("original-title").replace /,/g, '<br />'
      gravity: 'e'
      fade:    true
      html:    true
    }
