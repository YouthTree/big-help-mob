BHM.require('Authentication', function() {
  return BHM.withNS('RPXNow', function(ns) {
    var conditionallySet;
    ns.rpxnowLinkSelector = '.rpxnow';
    ns.dataPrefix = 'rpxnow-';
    ns.baseConfiguration = {
      overlay: true,
      language_preference: 'en'
    };
    conditionallySet = function conditionallySet(element, key, callback) {
      key = ("" + ns.dataPrefix + key);
      if (ns.hasData(element, key)) {
        return callback(ns.data(element, key));
      }
    };
    ns.configuration = function configuration() {
      var configuration, element;
      configuration = $.extend({}, ns.baseConfiguration);
      element = $(ns.rpxnowLinkSelector);
      // Set each of the data attributes.
      conditionallySet(element, "token-url", function(v) {
        configuration.token_url = v;
        return configuration.token_url;
      });
      conditionallySet(element, "realm", function(v) {
        configuration.realm = v;
        return configuration.realm;
      });
      conditionallySet(element, "flags", function(v) {
        configuration.flags = v;
        return configuration.flags;
      });
      return configuration;
    };
    ns.configureRPXNow = function configureRPXNow() {
      if ((typeof RPXNOW !== "undefined" && RPXNOW !== null)) {
        return $.extend(RPXNOW, ns.configuration());
      }
    };
    ns.setup = function setup() {
      return ns.configureRPXNow();
    };
    return ns.setup;
  });
});