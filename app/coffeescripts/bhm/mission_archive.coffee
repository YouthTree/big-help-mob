BHM.withNS 'MissionArchive', (ns) ->

  ns.setup = ->
    count = 0
    $(".mission-photos").each ->
      current = $ @
      # Get the maximum number of photos allowed if the photoset id is present.
      YouthTree.Flickr.Gallery.fromPhotoset "mission-photos-\#{++count}", current, current.dataAttr('photoset-id'), per_page: 10