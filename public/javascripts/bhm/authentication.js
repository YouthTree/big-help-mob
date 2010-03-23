BHM.withNS('Authentication', function(ns) {
  
  ns.traditionalAuthenticationSelector = '#traditional-authentication-link';
  ns.rpxnowAuthenticationSelector      = '#rpxnow-authentication-link';
  ns.authMethodSelector                = '#auth-selector-link'
  ns.containerSelector                 = '#authentication-choices';
  ns.traditionalFormSelector           = '#authentication-with-standard-account';
  
  ns.showTraditional = function() {
    $(ns.traditionalFormSelector).slideDown();
    $(ns.containerSelector).slideUp();
  };
  
  ns.showSelector = function() {
    $(ns.containerSelector).slideDown();
    $(ns.traditionalFormSelector).slideUp();
  }
  
  ns.bindEvents = function() {
    $(ns.traditionalAuthenticationSelector).click(function() {
      ns.showTraditional();
      return false;
    });
    $(ns.authMethodSelector).click(function() {
      ns.showSelector();
      return false;
    });
  };
  
  ns.setup = function() {  
    ns.bindEvents();
  };
  
});