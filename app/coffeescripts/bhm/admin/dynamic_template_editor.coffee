BHM.withNS 'Admin.DynamicTemplateEditor', (ns) ->

  ns.editorSelector      = '#dynamic_template_content'
  ns.contentTypeSelector = '#dynamic_template_content_type'
  
  CKEditor = YouthTree.Forms.CKEditor
  
  ns.shouldShowEditor = ->
    $(ns.contentTypeSelector).val() is "html"
  
  ns.showEditor = ->
    CKEditor.makeEditor $(ns.editorSelector)
    
  ns.hideEditor = ->
    CKEditor.destroyEditor $(ns.editorSelector)
  
  ns.toggleEditor = ->
    if ns.shouldShowEditor()
      ns.showEditor()
    else
      ns.hideEditor()
  
  ns.attachEvents = ->
    $(ns.contentTypeSelector).change(-> ns.toggleEditor()).change()
    
  ns.setup = -> ns.attachEvents()