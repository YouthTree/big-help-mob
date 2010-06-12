BHM.withNS 'ShareThis', (ns) ->

  ns.shareThisSelector: 'a.share-this'
  
  ns.getURL:   -> document.location.href
  ns.getTitle: -> document.title
  
  ns.getEntry: ->
    SHARETHIS.addEntry {
      title: ns.getTitle()
      url:   ns.getURL()
    }
  
  ns.attachEvents: ->
    entry: ns.getEntry()
    $(ns.shareThisSelector).show().click(-> false).each(->
      destination: ns.data $(@), "share-this-target"
      if destination?
        entry.attachChicklet destination, @
      else
        entry.attachButton @
    )
  
  ns.setup: -> ns.attachEvents()
  
  
