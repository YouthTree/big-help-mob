BHM.withNS('Flash', function(ns) {
  ns.parentSelector = '#flash-messages';
  ns.insideSelector = 'p.flash';
  ns.hideTimeout = 5000;
  ns.hideAllFlash = function hideAllFlash() {
    return $(("" + ns.parentSelector + " " + ns.insideSelector)).each(function() {
      return ns.hideFlash(this);
    });
  };
  ns.hideFlash = function hideFlash(e) {
    return $(e).slideUp(function() {
      return $(this).remove();
    });
  };
  ns.setupTimers = function setupTimers() {
    return setTimeout((function() {
      return ns.hideAllFlash();
    }), ns.hideTimeout);
  };
  ns.attachClickEvents = function attachClickEvents() {
    return $(("" + ns.parentSelector + " " + ns.insideSelector)).click(function() {
      ns.hideFlash(this);
      return false;
    });
  };
  ns.setup = function setup() {
    if ($(ns.parentSelector).size() < 1) {
      return null;
    }
    ns.setupTimers();
    return ns.attachClickEvents();
  };
  return ns.setup;
});