BHM.withNS 'SubscriberButton', (ns) ->

  ns.buttonSelector = '.subscribe-to-mailing-list'
  
  ns.subscribersURL = '/subscribers/new'

  ns.showSubscriptionWindow = ->
    $.get ns.subscribersURL, (data) ->
      $.facybox data
  
  ns.bindEvents = ->
    $(ns.buttonSelector).click (e) ->
      ns.showSubscriptionWindow()
      false

  ns.setup = ->
    $(document).ready ->  ns.bindEvents()
      
    