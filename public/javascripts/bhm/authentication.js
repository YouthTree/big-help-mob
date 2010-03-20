BHM.withNS('Authentication', function(ns) {
  
  ns.traditionalSignupSelector = '#traditional-authentication-link';
  ns.rpxnowSignupSelector      = '#rpxnow-authentication-link';
  ns.containerSelector         = '#authentication-choices';
  ns.traditionalFormSelector   = '#authentication-with-standard-account';
  
  ns.showTraditional = function() {
    $(ns.traditionalFormSelector).slideDown();
    $(ns.containerSelector).slideUp(function() {
      $(this).remove();
    });
  };
  
  ns.bindEvents = function() {
    $(ns.traditionalSignupSelector).click(function() {
      ns.showTraditional();
      return false;
    });
  };
  
  ns.setup = function() {  
    ns.bindEvents();
  };
  
  $(document).ready(ns.setup);
  
});