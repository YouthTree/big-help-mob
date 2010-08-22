BHM.withNS('CKEditor', function(ns) {
  var currentEditorOptions;
  window.CKEDITOR_BASEPATH = '/ckeditor/';
  ns.editorSelector = '.ckeditor textarea';
  ns.editorOptions = {
    toolbar: 'bhm',
    width: '71%',
    customConfig: false
  };
  ns.toolbar_layout = [['Source', '-', 'Templates'], ['Cut', 'Copy', 'Paste', 'PasteText', 'PasteFromWord', '-', 'SpellChecker', 'Scayt'], ['Undo', 'Redo', '-', 'Find', 'Replace', 'RemoveFormat'], '/', ['Bold', 'Italic', 'Underline', 'Strike'], ['NumberedList', 'BulletedList', 'Blockquote'], ['JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyBlock'], ['Link', 'Unlink', 'Anchor'], ['Image', 'Flash', 'Table', 'HorizontalRule'], '/', ['Styles', 'Format', 'Font', 'FontSize'], ['TextColor', 'BGColor'], ['Maximize', 'ShowBlocks']];
  currentEditorOptions = function() {
    var options;
    options = $.extend({}, ns.editorOptions);
    options.toolbar_bhm = ns.toolbar_layout;
    return options;
  };
  ns.makeEditor = function(jq) {
    return jq.ckeditor(currentEditorOptions());
  };
  ns.destroyEditor = function(jq) {
    var _a;
    return typeof (_a = (jq.ckeditorGet())) === "undefined" || _a == undefined ? undefined : _a.destroy();
  };
  return (ns.setup = function() {
    return ns.makeEditor($(ns.editorSelector));
  });
});