BHM.withNS('Admin.DynamicTemplateEditor', function(ns) {
  
  ns.editorSelector      = '#dynamic_template_content';
  ns.contentTypeSelector = '#dynamic_template_content_type';
  
  ns.shouldShowEditor = function() {
    return $(ns.contentTypeSelector).val() == "html";
  };
  
  ns.showEditor = function() {
    BHM.CKEditor.makeEditor($(ns.editorSelector).addClass('ckeditor'));
  };
  
  ns.hideEditor = function() {
    BHM.CKEditor.destroyEditor($(ns.editorSelector).removeClass('ckeditor'));
  };
  
  ns.toggleEditor = function() {
    ns.shouldShowEditor() ? ns.showEditor() : ns.hideEditor();
  }
  
  ns.attachEvents = function() {
    $(ns.contentTypeSelector).change(function() {
      ns.toggleEditor();
    }).change();
  };
  
  ns.setup = function() { ns.attachEvents(); };
  
});