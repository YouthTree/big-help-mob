BHM.withNS('Admin.Questions', function(ns) {
  
  ns.reorderQuestionsURL = '/admin/questions/reorder';
  ns.dialogSelector      = '#reorder-questions';
  ns.sortableSelector    = 'ul';
  ns.linkSelector        = '.reorder-questions-link';
  
  var sortable = false;
  
  ns.showReorderDialog = function() {
    ns.makeSortable();
    $(ns.dialogSelector).dialog();
  };
  
  ns.makeSortable = function() {
    if(sortable) return;
    $(ns.dialogSelector + ' ' + ns.sortableSelector).sortable();
    sortable = true;
  }
  
  ns.bindReorderButton = function() {
    $(ns.linkSelector).click(function() {
      ns.showReorderDialog();
      return false;
    });
  }
  
  ns.setup = function() {
    ns.bindReorderButton();
  };
  
});