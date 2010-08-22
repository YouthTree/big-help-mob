BHM.withNS('Flash', function(ns) {
  ns.parentSelector = '#flash-messages';
  ns.insideSelector = 'p.flash';
  ns.hideTimeout = 5000;
  ns.hideAllFlash = function() {
    return $(("" + (ns.parentSelector) + " " + (ns.insideSelector))).each(function() {
      return ns.hideFlash(this);
    });
  };
  ns.hideFlash = function(e) {
    return $(e).slideUp(function() {
      return $(this).remove();
    });
  };
  ns.setupTimers = function() {
    return setTimeout((function() {
      return ns.hideAllFlash();
    }), ns.hideTimeout);
  };
  ns.attachClickEvents = function() {
    return $(("" + (ns.parentSelector) + " " + (ns.insideSelector))).click(function() {
      ns.hideFlash(this);
      return false;
    });
  };
  return (ns.setup = function() {
    if ($(ns.parentSelector).size() < 1) {
      return null;
    }
    ns.setupTimers();
    return ns.attachClickEvents();
  });
});