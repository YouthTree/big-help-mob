BHM.withNS 'Mission', (ns) ->

  ns.abbrselector: '#pickups-listing li abbr'
  ns.imgSelector:  '#mission-photos a'

  ns.setup: ->
    $(ns.abbrSelector).tipsy {
      title:   -> this.getAttribute("original-title").replace /,/g, '<br />'
      gravity: 'e'
      fade:    true
      html:    true
    }
    YouthTree.Gallery.create 'mission-gallery', ns.imgSelector
    ns.bindNinjas()

  ns.unicorns: ->
    gallery: YouthTree.Gallery.get 'mission-gallery'
    items: gallery.items
    perRow: 9
    rows: Math.ceil(items.size() / perRow)
    cycleRows: (cb) ->
      row: 0
      setInterval((->
        start: row * perRow
        cb items.slice(start, start + perRow), items
        row: (row + 1) % rows
      ), 250)
    cycleColumns: (cb) ->
      column: 0
      setInterval((->
        column: (column + 1) % perRow
        cb items.filter(":nth-child(${perRow}n+${column})"), items
      ), 250)
    [cycleRows, cycleColumns]

  ns.ninjas: ->
    cb: (i, i2) ->
      i2.removeClass 'active'
      i.addClass 'active'
    u: ns.unicorns()
    u[0] cb
    setTimeout((-> u[1] cb), 125)
  
  ns.bindNinjas: ->
    keys: []
    code: "66,72,77"
    $(document).keydown (e) ->
      keys.push e.keyCode
      if keys.join(",").indexOf(code) > -1
        ns.ninjas()
        $(@).unbind 'keydown'
