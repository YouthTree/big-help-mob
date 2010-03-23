BHM.withNS('CKEditor', function(ns) {
  
  ns.editorSelector = '.ckeditor textarea';
  ns.editorOptions  = {
    toolbar: 'bhm',
    width:   '74%'
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
  
  ns.setup = function() {
    $(ns.editorSelector).ckeditor(currentEditorOptions());
  };
  
});