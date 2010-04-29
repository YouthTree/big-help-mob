BHM.withNS 'Coffee', (ns) ->

  window.CKEDITOR_BASEPATH: '/ckeditor/'
  
  ns.editorSelector: '.ckeditor textarea'
  ns.editorOptions: {
    toolbar:      'bhm'
    width:        '71%'
    customConfig: false
  }
  
  ns.toolbar_layout = [
    ['Source','-','Templates'], ['Cut','Copy','Paste','PasteText','PasteFromWord','-', 'SpellChecker', 'Scayt'],
    ['Undo','Redo','-','Find','Replace','RemoveFormat'],
    '/',
    ['Bold','Italic','Underline','Strike'], ['NumberedList','BulletedList', 'Blockquote'],
    ['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'], ['Link','Unlink','Anchor'], ['Image','Flash','Table','HorizontalRule'],
    '/',
    ['Styles','Format','Font','FontSize'], ['TextColor','BGColor'], ['Maximize', 'ShowBlocks']
  ]
  
  currentEditorOptions: ->
    options: $.extend {}, ns.editorOptions
    options.toolbar_bhm: ns.toolbar_layout
    options
    
  ns.makeEditor: (jq) ->
    jq.ckeditor currentEditorOptions()
    
  ns.destroyEditor: (jq) ->
    jq.ckeditorGet()?.destroy()
    
  ns.setup: -> ns.makeEditor $(ns.editorSelector)
