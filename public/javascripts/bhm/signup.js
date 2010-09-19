var __bind = function(func, context) {
    return function(){ return func.apply(context, arguments); };
  };
BHM.withNS('Signup', function(ns) {
  ns.originWrapperSelector = '#user_origin_input';
  ns.replaceField = function() {
    var container, id, name, select;
    container = $(ns.originWrapperSelector);
    container.removeClass('select').addClass('string');
    select = container.find('select');
    id = select.attr("id");
    name = select.attr("name");
    select.remove();
    return container.find('label').after($('<input />', {
      name: name,
      id: id,
      type: 'text'
    }));
  };
  ns.shouldReplaceField = function() {
    return $("" + (ns.originWrapperSelector) + " select").val().toLowerCase() === 'other';
  };
  ns.attachEvents = function() {
    return $("" + (ns.originWrapperSelector) + " select").change(__bind(function() {
      if (ns.shouldReplaceField()) {
        return ns.replaceField();
      }
    }, this));
  };
  return (ns.setup = function() {
    return ns.attachEvents();
  });
});