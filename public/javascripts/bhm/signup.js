BHM.withNS('Signup', function(ns) {
  
  ns.originWrapperSelector = '#user_origin_input';
  
  ns.replaceField = function() {
    var container = $(ns.originWrapperSelector);
    container.removeClass('select').addClass('string');
    var select = container.find('select');
    var id   = select.attr("id"),
        name = select.attr("name");
    select.remove();
    container.find('label').after($("<input />", {'name': name, 'id': id, 'type': 'text'}));
  };
  
  ns.shouldReplaceField = function() {
    return $(ns.originWrapperSelector + ' select').val().toLowerCase() == "other";
  };
  
  ns.attachEvents = function() {
    $(ns.originWrapperSelector + ' select').change(function() {
      if(ns.shouldReplaceField()) ns.replaceField();
    });
  };
  
  ns.setup = function() {
    ns.attachEvents();
  };
  
});