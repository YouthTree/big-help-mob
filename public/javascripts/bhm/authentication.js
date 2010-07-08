BHM.withNS('Authentication', function(ns) {
  ns.traditionalAuthenticationSelector = '#traditional-authentication-link';
  ns.rpxnowAuthenticationSelector = '#rpxnow-authentication-link';
  ns.authMethodSelector = '#auth-selector-link';
  ns.containerSelector = '#authentication-choices';
  ns.traditionalFormSelector = '#authentication-with-standard-account';
  ns.showTraditional = function showTraditional() {
    $(ns.traditionalFormSelector).slideDown();
    return $(ns.containerSelector).slideUp();
  };
  ns.showSelector = function showSelector() {
    $(ns.containerSelector).slideDown();
    return $(ns.traditionalFormSelector).slideUp();
  };
  ns.bindEvents = function bindEvents() {
    $(ns.traditionalAuthenticationSelector).click(function() {
      ns.showTraditional();
      return false;
    });
    return $(ns.authMethodSelector).click(function() {
      ns.showSelector();
      return false;
    });
  };
  ns.setup = function setup() {
    return ns.bindEvents();
  };
  return ns.setup;
});