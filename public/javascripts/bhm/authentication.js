BHM.withNS('Authentication', function(ns) {
  ns.traditionalAuthenticationSelector = '#traditional-authentication-link';
  ns.rpxnowAuthenticationSelector = '#rpxnow-authentication-link';
  ns.authMethodSelector = '#auth-selector-link';
  ns.containerSelector = '#authentication-choices';
  ns.traditionalFormSelector = '#authentication-with-standard-account';
  ns.showTraditional = function() {
    $(ns.traditionalFormSelector).slideDown();
    return $(ns.containerSelector).slideUp();
  };
  ns.showSelector = function() {
    $(ns.containerSelector).slideDown();
    return $(ns.traditionalFormSelector).slideUp();
  };
  ns.bindEvents = function() {
    $(ns.traditionalAuthenticationSelector).click(function() {
      ns.showTraditional();
      return false;
    });
    return $(ns.authMethodSelector).click(function() {
      ns.showSelector();
      return false;
    });
  };
  return (ns.setup = function() {
    return ns.bindEvents();
  });
});