BHM.withNS 'IE6', (ns) ->
  
  ns.belatedPNGSelectors = [
    "nav#header-menu"
    "#youthtree-project-logo a"
    "header h1 a"
    " button"
    ".join-as-button a"
    "a#auth-selector-link"
    "#authentication-choices dd.choice a"
  ]
  
  ns.setup = ->
    if DD_belatedPNG?
      $(ns.belatedPNGSelectors.join(", ")).each -> DD_belatedPNG.fixPng @