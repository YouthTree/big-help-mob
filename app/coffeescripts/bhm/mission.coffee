BHM.withNS 'Mission', (ns) ->

  ns.abbrSelector    = '#pickups-listing li abbr'
  ns.gallerySelector = '#mission-photos'

  ns.setup = ->
    $(ns.abbrSelector).tipsy
      title:   -> @getAttribute("original-title").replace /,/g, "<br/>"
      gravity: 'e'
      fade:    true
      html:    true
    photos = $("#mission-photos")
    if photos.length
      # Get the maximum number of photos allowed if the photoset id is present.
      YouthTree.Flickr.Gallery.fromPhotoset 'mission-photos', photos, photos.dataAttr('photoset-id'), per_page: 500
    