BHM.withNS 'Admin.DynamicTemplateEditor', (ns) ->

  ns.editorSelector:      '#dynamic_template_content'
  ns.contentTypeSelector: '#dynamic_template_content_type'
  
  ns.shouldShowEditor: ->
    $(ns.contentTypeSelector).val() is "html"
  
  ns.showEditor: ->
    BHM.CKEditor.makeEditor $(ns.editorSelector).addClass('ckeditor')
    
  ns.hideEditor: ->
    BHM.CKEditor.destroyEditor $(ns.editorSelector).removeClass('ckeditor')
  
  ns.toggleEditor: ->
    if ns.shouldShowEditor()
      ns.showEditor()
    else
      ns.hideEditor()
  
  ns.attachEvents: ->
    $(ns.contentTypeSelector).change(-> ns.toggleEditor()).change()
    
  ns.setup: -> ns.attachEvents()