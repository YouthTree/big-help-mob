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
    return ns.shouldShowEditor() ? ns.showEditor() : ns.hideEditor();
  };
  ns.attachEvents = function() {
    return $(ns.contentTypeSelector).change(function() {
      return ns.toggleEditor();
    }).change();
  };
  return (ns.setup = function() {
    return ns.attachEvents();
  });
});