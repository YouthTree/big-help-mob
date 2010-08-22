BHM.withNS('IE6', function(ns) {
  ns.belatedPNGSelectors = ["nav#header-menu", "#youthtree-project-logo a", "header h1 a", " button", ".join-as-button a", "a#auth-selector-link", "#authentication-choices dd.choice a"];
  return (ns.setup = function() {
    return (typeof DD_belatedPNG !== "undefined" && DD_belatedPNG !== null) ? $(ns.belatedPNGSelectors.join(", ")).each(function() {
      return DD_belatedPNG.fixPng(this);
    }) : null;
  });
});