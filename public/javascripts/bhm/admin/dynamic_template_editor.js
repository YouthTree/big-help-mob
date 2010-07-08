BHM.withNS('Admin.DynamicTemplateEditor', function(ns) {
  ns.editorSelector = '#dynamic_template_content';
  ns.contentTypeSelector = '#dynamic_template_content_type';
  ns.shouldShowEditor = function() {
    return $(ns.contentTypeSelector).val() === "html";
  };
  ns.showEditor = function() {
    return BHM.CKEditor.makeEditor($(ns.editorSelector));
  };
  ns.hideEditor = function() {
    return BHM.CKEditor.destroyEditor($(ns.editorSelector));
  };
  ns.toggleEditor = function() {
    if (ns.shouldShowEditor()) {
      return ns.showEditor();
    } else {
      return ns.hideEditor();
    }
  };
  ns.attachEvents = function() {
    return $(ns.contentTypeSelector).change(function() {
      return ns.toggleEditor();
    }).change();
  };
  ns.setup = function() {
    return ns.attachEvents();
  };
  return ns.setup;
});