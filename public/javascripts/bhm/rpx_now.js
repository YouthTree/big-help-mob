BHM.require('Authentication').load(function() {
  BHM.withNS('RPXNow', function(ns) {

    ns.rpxnowLinkSelector = '.rpxnow';
    ns.baseConfiguration  = {
      overlay: true,
      language_preference: 'en'
    };

    ns.dataPrefix = 'rpxnow-';

    function hasData(elem, key) {
      return elem.is("[data-" + ns.dataPrefix + key + "]");
    }

    function getData(elem, key) {
      return elem.attr("data-" + ns.dataPrefix + key);
    }
    ns.configuration = function() {
      var c = $.extend({}, ns.baseConfiguration);
      var l = $(ns.rpxnowLinkSelector);
      if(hasData(l, "token-url")) c.token_url = getData(l, "token-url");
      if(hasData(l, "realm"))     c.realm = getData(l, "realm");
      if(hasData(l, "flags"))     c.flags = getData(l, "flags");
      return c;
    };
    
    ns.configureRPXNow = function() {
      if(typeof(RPXNOW) != "undefined") $.extend(RPXNOW, ns.configuration());
    };
    
    ns.setup = function() {
      ns.configureRPXNow();
    };

  });
});