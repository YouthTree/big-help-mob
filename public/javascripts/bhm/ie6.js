BHM.withNS('IE6', function(ns) {
  ns.belatedPNGSelectors = ["nav#header-menu", "#youthtree-project-logo a", "header h1 a", " button", ".join-as-button a", "a#auth-selector-link", "#authentication-choices dd.choice a"];
  ns.setup = function() {
    if (typeof DD_belatedPNG !== "undefined" && DD_belatedPNG !== null) {
      return $(ns.belatedPNGSelectors.join(", ")).each(function() {
        return DD_belatedPNG.fixPng(this);
      });
    }
  };
  return ns.setup;
});