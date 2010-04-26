BHM.require 'Authentication', ->
  BHM.withNS 'RPXNow', (ns) ->
    
    ns.rpxnowLinkSelector: '.rpxnow'
    ns.dataPrefix: 'rpxnow-'
    ns.baseConfiguration: {
      overlay: true
      language_preference: 'en'
    }
    
    conditionallySet: (element, key, callback) ->
      key: "$ns.dataPrefix$key"
      callback ns.data(element, key) if ns.hasData element, key
    
    ns.configuration: ->
      configuration: $.extend {}, ns.baseConfiguration
      element:       $ ns.rpxnowLinkSelector
      # Set each of the data attributes.
      conditionallySet element, "token-url", (v) -> configuration.token_url: v
      conditionallySet element, "realm",     (v) -> configuration.realm:     v
      conditionallySet element, "flags",     (v) -> configuration.flags:     v
      configuration
    
    ns.configureRPXNow: ->
      $.extend RPXNOW, ns.configuration() if RPXNOW?
      
    ns.setup: -> ns.configureRPXNow()
      