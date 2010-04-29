BHM.withNS 'Admin.QuestionEditor', (ns) ->
  
  ns.fieldsetSelector:   '.question-input'
  ns.individualSelector: 'select'
  ns.itemSelector:       '.question-metadata'
  ns.showValue:          'multiple_choice'
  ns.removeSelector:     'a.remove-question-link'
  ns.addSelector:        'a.add-question-link'
  ns.template:           ''
  
  ns.attachEvents: ->
    $(ns.addSelector).click ->
      ns.addQuestion()
      false
    $(ns.fieldsetSelector).each -> ns.attachEventOn $(this)
  
  ns.attachEventOn: (fieldset) ->
    fieldset.find("select").change(->
      if ns.shouldShow(fieldset)
        ns.showMetadata fieldset
      else
        ns.hideMetadata fieldset
    ).change()
    fieldset.find(ns.removeSelector).click ->
      ns.deleteQuestion @
      false
  
  ns.hideMetadata: (c) ->
    c.find(ns.itemSelector).hide()
    
  ns.showMetadata: (c) ->
    c.find(ns.itemSelector).show()
  
  ns.shouldShow: (c) ->
    c.find(ns.individualSelector).val() is ns.showValue
  
  ns.addQuestion: ->
    inner: ns.template.replace /QUESTION_IDX/g, Number(new Date())
    $("$ns.fieldsetSelector:last").after inner
    ns.attachEventOn $("$ns.fieldsetSelector:last")
  
  ns.deleteQuestion: (link) ->
    link: $ link
    link.parents(ns.fieldsetSelector).find('input[type=hidden]').val('1').end().hide()
    
  ns.setup: -> ns.attachEvents()
    