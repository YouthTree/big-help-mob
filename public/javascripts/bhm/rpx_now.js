BHM.require('Authentication', function() {
  return BHM.withNS('RPXNow', function(ns) {
    var conditionallySet;
    ns.rpxnowLinkSelector = '.rpxnow';
    ns.dataPrefix = 'rpxnow-';
    ns.baseConfiguration = {
      overlay: true,
      language_preference: 'en'
    };
    conditionallySet = function(element, key, callback) {
      key = ("" + (ns.dataPrefix) + (key));
      if (ns.hasData(element, key)) {
        return callback(ns.data(element, key));
      }
    };
    ns.configuration = function() {
      var configuration, element;
      configuration = $.extend({}, ns.baseConfiguration);
      element = $(ns.rpxnowLinkSelector);
      conditionallySet(element, "token-url", function(v) {
        return (configuration.token_url = v);
      });
      conditionallySet(element, "realm", function(v) {
        return (configuration.realm = v);
      });
      conditionallySet(element, "flags", function(v) {
        return (configuration.flags = v);
      });
      return configuration;
    };
    ns.configureRPXNow = function() {
      if (typeof RPXNOW !== "undefined" && RPXNOW !== null) {
        return $.extend(RPXNOW, ns.configuration());
      }
    };
    return (ns.setup = function() {
      return ns.configureRPXNow();
    });
  });
});