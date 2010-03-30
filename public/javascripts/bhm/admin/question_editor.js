BHM.withNS('Admin.QuestionEditor', function(ns) {
  
  ns.fieldsetSelector   = '.question-input';
  ns.individualSelector = 'select';
  ns.itemSelector       = '.question-metadata';
  ns.showValue          = 'multiple_choice';
  ns.removeSelector     = 'a.remove-question-link';
  ns.addSelector        = 'a.add-question-link';
  ns.template           = '';
  
  ns.attachEvents = function() {
    $(ns.addSelector).click(function() {
      ns.addQuestion();
      return false;
    })
    $(ns.fieldsetSelector).each(function() { ns.attachEventOn($(this)); });
  };
  
  ns.attachEventOn = function(fs) {
    fs.find('select').change(function() {
      ns[(ns.shouldShow(fs) ? "show" : "hide") + "Metadata"](fs);
    }).change();
    fs.find(ns.removeSelector).click(function() {
      ns.deleteQuestion(this);
      return false;
    })
  };
  
  ns.hideMetadata = function(c) {
    c.find(ns.itemSelector).hide();
  };
  
  ns.showMetadata = function(c) {
    c.find(ns.itemSelector).show();
  };
  
  ns.shouldShow = function(c) {
    return c.find(ns.individualSelector).val() == ns.showValue;
  };
  
  ns.addQuestion = function() {
    var inner = ns.template.replace(/QUESTION_IDX/g, Number(new Date()));
    $(ns.fieldsetSelector + ":last").after(inner);
    ns.attachEventOn($(ns.fieldsetSelector + ":last"));
  }
  
  ns.deleteQuestion = function(link) {
    var link = $(link);
    link.parents(ns.fieldsetSelector).find('input[type=hidden]').val('1').end().hide();
  };
  
  ns.setup = function() {
    ns.attachEvents();
  };
  
});