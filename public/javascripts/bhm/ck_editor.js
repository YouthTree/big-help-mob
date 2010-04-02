BHM.withNS('CKEditor', function(ns) {
  
  window.CKEDITOR_BASEPATH = '/ckeditor/';
  
  ns.editorSelector = '.ckeditor textarea';
  ns.editorOptions  = {
    toolbar:      'bhm',
    width:        '71%',
    customConfig: false
  };
  
  ns.toolbar_layout = [
  	['Source','-','Templates'], ['Cut','Copy','Paste','PasteText','PasteFromWord','-', 'SpellChecker', 'Scayt'],
  	['Undo','Redo','-','Find','Replace','RemoveFormat'],
  	'/',
  	['Bold','Italic','Underline','Strike'], ['NumberedList','BulletedList', 'Blockquote'],
  	['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'], ['Link','Unlink','Anchor'], ['Image','Flash','Table','HorizontalRule'],
  	'/',
  	['Styles','Format','Font','FontSize'], ['TextColor','BGColor'], ['Maximize', 'ShowBlocks']
  ];
  
  function currentEditorOptions() {
    var o = $.extend({}, ns.editorOptions)
    o.toolbar_bhm = ns.toolbar_layout;
    return o;
  }
  
  ns.makeEditor = function(jq) {
    jq.ckeditor(currentEditorOptions());
  };
  
  ns.destroyEditor = function(jq) {
    try { jq.ckeditorGet().destroy(); } catch(e) {};
  }
  
  ns.setup = function() {
    ns.makeEditor($(ns.editorSelector));
  };
  
});