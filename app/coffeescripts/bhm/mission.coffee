BHM.withNS 'Mission', (ns) ->

  ns.abbrselector = '#pickups-listing li abbr'
  ns.imgSelector  = '#mission-photos a'

  ns.setup = ->
    $(ns.abbrSelector).tipsy
      title:   -> @getAttribute("original-title").replace /,/g, "<br/>"
      gravity: 'e'
      fade:    true
      html:    true
    YouthTree.Gallery.create 'mission-gallery', ns.imgSelector