BHM.withNS('BgColourTest', function(ns) {
  
  ns.getCurrentColour = function() {
    return $("body, html").css("background-color");
  };
  
  ns.setCurrentColour = function(c) {
    $("body, html").css("background-color", c);
  };
  
  ns.attachEvents = function() {
    $('#bg-colour-picker').ColorPicker({
      color:  ns.getCurrentColour(),
      onShow: function(picker) {
        $(picker).fadeIn(500);
        return false;
      },
      onHide: function(picker) {
        $(picker).fadeOut(500);
        return false;
      },
      onChange: function(hsb, hex, rgb) {
        ns.setCurrentColour("#" + hex);
      }
    });
    $("#bg-colour-picker").click(function() { return false; });
  };
  
  ns.setup = function() { ns.attachEvents(); };
  
});