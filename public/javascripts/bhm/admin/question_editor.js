BHM.withNS('Admin.QuestionEditor', function(ns) {
  ns.fieldsetSelector = '.question-input';
  ns.individualSelector = 'select';
  ns.itemSelector = '.question-metadata';
  ns.showValue = 'multiple_choice';
  ns.removeSelector = 'a.remove-question-link';
  ns.addSelector = 'a.add-question-link';
  ns.template = '';
  ns.attachEvents = function attachEvents() {
    $(ns.addSelector).click(function() {
      ns.addQuestion();
      return false;
    });
    return $(ns.fieldsetSelector).each(function() {
      return ns.attachEventOn($(this));
    });
  };
  ns.attachEventOn = function attachEventOn(fieldset) {
    fieldset.find("select").change(function() {
      if (ns.shouldShow(fieldset)) {
        return ns.showMetadata(fieldset);
      } else {
        return ns.hideMetadata(fieldset);
      }
    }).change();
    return fieldset.find(ns.removeSelector).click(function() {
      ns.deleteQuestion(this);
      return false;
    });
  };
  ns.hideMetadata = function hideMetadata(c) {
    return c.find(ns.itemSelector).hide();
  };
  ns.showMetadata = function showMetadata(c) {
    return c.find(ns.itemSelector).show();
  };
  ns.shouldShow = function shouldShow(c) {
    return c.find(ns.individualSelector).val() === ns.showValue;
  };
  ns.addQuestion = function addQuestion() {
    var inner;
    inner = ns.template.replace(/QUESTION_IDX/g, Number(new Date()));
    $(("" + ns.fieldsetSelector + ":last")).after(inner);
    return ns.attachEventOn($(("" + ns.fieldsetSelector + ":last")));
  };
  ns.deleteQuestion = function deleteQuestion(link) {
    link = $(link);
    return link.parents(ns.fieldsetSelector).find('input[type=hidden]').val('1').end().hide();
  };
  ns.setup = function setup() {
    return ns.attachEvents();
  };
  return ns.setup;
});