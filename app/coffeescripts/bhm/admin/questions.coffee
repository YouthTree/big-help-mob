BHM.withNS 'Admin.Questions', (ns) ->  

  ns.reorderQuestionsURL = '/admin/questions/reorder'
  ns.dialogSelector      = '#reorder-questions'
  ns.sortableSelector    = 'ul'
  ns.linkSelector        = '.reorder-questions-link'
  
  sortable = false
  
  ns.showReorderDialog = ->
    ns.makeSortable()
    $(ns.dialogSelector).dialog()
  
  ns.makeSortable = ->
    return if sortable
    $("#{ns.dialogSelector} #{ns.sortableSelector}").sortable()
    sortable = true
  
  ns.bindReorderButton = ->
    $(ns.linkSelector).click ->
      ns.showReorderDialog()
      false
  
  ns.setup = -> ns.bindReorderButton()