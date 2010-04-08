BHM.withNS('Analytics', function(ns) {
  
  function metaAttr(name) {
   return $("meta[name=" + name + "]").attr("content");
  }
  
  ns.tracker = null;
  ns.apiKey  = null;
  
  ns.trackPageView = function() {
    if(ns.tracker) ns.tracker._trackPageview();
  };
  
  ns.trackCurrent = function() {
    ns.trackPageView();
  };
  
  ns.setupTracker = function() {
    ns.apiKey = metaAttr("google-analytics-key");
    if(typeof(_gat) != "undefined" && ns.apiKey)
      ns.tracker = _gat._getTracker(ns.apiKey);
  };
  
  ns.setup = function() {
    ns.setupTracker();
  };
  
});