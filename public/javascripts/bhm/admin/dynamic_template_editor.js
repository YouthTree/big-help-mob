BHM.withNS('Admin.DynamicTemplateEditor', function(ns) {
  ns.editorSelector = '#dynamic_template_content';
  ns.contentTypeSelector = '#dynamic_template_content_type';
  ns.shouldShowEditor = function shouldShowEditor() {
    return $(ns.contentTypeSelector).val() === "html";
  };
  ns.showEditor = function showEditor() {
    return BHM.CKEditor.makeEditor($(ns.editorSelector));
  };
  ns.hideEditor = function hideEditor() {
    return BHM.CKEditor.destroyEditor($(ns.editorSelector));
  };
  ns.toggleEditor = function toggleEditor() {
    if (ns.shouldShowEditor()) {
      return ns.showEditor();
    } else {
      return ns.hideEditor();
    }
  };
  ns.attachEvents = function attachEvents() {
    return $(ns.contentTypeSelector).change(function() {
      return ns.toggleEditor();
    }).change();
  };
  ns.setup = function setup() {
    return ns.attachEvents();
  };
  return ns.setup;
});