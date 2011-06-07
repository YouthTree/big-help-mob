BHM.withNS 'RPXSharing', (ns) ->

  ns.baseConfiguration  =
    xdReceiver: '/rpx_xdcomm.html'
    
  ns.shareButtonSelector = 'a.rpx-share-button'


  ns.shareActivity = (title, content, url) ->
    RPXNOW.loadAndRun ['Social'], ->
      activity = new RPXNOW.Social.Activity title, content, url
      RPXNOW.Social.publishActivity activity
  
  ns.configuration = ->
    configuration = $.extend {}, ns.baseConfiguration
    configuration.app_id = $.metaAttr("rpx-app-id")
    
  ns.setupSharingButtons = ->
    $(ns.shareButtonSelector).click (e) ->
      e.preventDefault()
      ns.shareActivity $(@).dataAttr("share-message"), $(@).dataAttr("share-content"), document.location.href

  ns.configureRPXNow = ->
    if RPXNOW?
      RPXNOW.init ns.configuration()

  ns.setup = ->
    ns.configureRPXNow()
    ns.setupSharingButtons()
