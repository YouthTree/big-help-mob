BHM.withNS 'Admin.DynamicTemplateEditor', (ns) ->

  ns.editorSelector      = '#dynamic_template_content'
  ns.contentTypeSelector = '#dynamic_template_content_type'
  
  ns.shouldShowEditor = ->
    $(ns.contentTypeSelector).val() is "html"
  
  ns.showEditor = ->
    BHM.CKEditor.makeEditor $(ns.editorSelector)
    
  ns.hideEditor = ->
    BHM.CKEditor.destroyEditor $(ns.editorSelector)
  
  ns.toggleEditor = ->
    if ns.shouldShowEditor()
      ns.showEditor()
    else
      ns.hideEditor()
  
  ns.attachEvents = ->
    $(ns.contentTypeSelector).change(-> ns.toggleEditor()).change()
    
  ns.setup = -> ns.attachEvents()