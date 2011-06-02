BHM.withNS 'ShareThis', (ns) ->

  ns.shareThisSelector = 'a.share-this'
  
  ns.getURL   = -> document.location.href
  ns.getTitle = -> document.title
  
  ns.getEntry = (title = ns.getTitle(), url = ns.getURL()) ->
    SHARETHIS.addEntry title: title, url: url, summary: title
  
  ns.attachEvents = ->
    $(ns.shareThisSelector).show().click((e) -> e.stopPropagation()).each ->
      target      = $ @
      destination = ns.data target, "share-this-target"
      title       = ns.data(target, "share-this-title") ? ns.getTitle()
      entry       = ns.getEntry title
      console.log entry
      if destination?
        entry.attachChicklet destination, @
      else
        entry.attachButton @
  
  ns.setup = -> ns.attachEvents()
  
  
