BHM.withNS('Flash', function(ns) {
  
  ns.parentSelector = '#flash-messages';
  ns.insideSelector = 'p.flash';
  ns.hideTimeout    = 5000; // 10 seconds.
  
  ns.hideAllFlash = function() {
    $(ns.parentSelector + ' ' + ns.insideSelector).each(function() { ns.hideFlash(this); });
  };
  
  ns.hideFlash = function(e) {
    $(e).slideUp(function() {
      $(this).remove();
    });
  };
  
  ns.setup = function() {
    if($(ns.parentSelector).size() < 1)  return;
    setTimeout(ns.hideAllFlash, ns.hideTimeout);
    $(ns.parentSelector + ' ' + ns.insideSelector).click(function() { ns.hideFlash(this); });
  }
  
  $(document).ready(ns.setup);
  
});