BHM.withNS('Admin.EmailEditor', function(ns) {
  ns.participationSelector = '#participations-filter';
  ns.typeSelector = 'select#email_scope_type';
  ns.previewSectionSelector = 'a.preview-email-section';
  ns.confirmedSelector = '#email_confirmed';
  ns.confirmedFieldset = 'fieldset#email-confirmation';
  ns.setButtonText = function setButtonText(text) {
    return $("#email_submit").text(text);
  };
  ns.hideConfirmation = function hideConfirmation() {
    $(ns.confirmedSelector).removeAttr("check");
    $(ns.confirmedFieldset).hide();
    return ns.setButtonText("Preview and Confirm");
  };
  ns.removePreviewFor = function removePreviewFor(field) {
    $(("#preview-of-" + field)).hide();
    return ns.hideConfirmation();
  };
  ns.hideParticipationFilter = function hideParticipationFilter() {
    return $(ns.participationSelector).hide();
  };
  ns.showParticipationFilter = function showParticipationFilter() {
    return $(ns.participationSelector).show();
  };
  ns.shouldShowParticipationFilter = function shouldShowParticipationFilter() {
    return $(ns.typeSelector).val() === "participations";
  };
  ns.toggleParticipationFilter = function toggleParticipationFilter() {
    if (ns.shouldShowParticipationFilter()) {
      return ns.showParticipationFilter();
    } else {
      return ns.hideParticipationFilter();
    }
  };
  ns.showPreviewFor = function showPreviewFor(scope) {
    scope = $(scope);
    return $.facybox({
      div: scope.attr("href")
    }, "email-section-preview");
  };
  ns.bindEvents = function bindEvents() {
    $(ns.typeSelector).change(function() {
      return ns.toggleParticipationFilter();
    }).change();
    $("#email_subject").change(function() {
      return ns.removePreviewFor("subject");
    });
    $("#email_text_content").change(function() {
      return ns.removePreviewFor("text-content");
    });
    return $(ns.previewSectionSelector).click(function() {
      ns.showPreviewFor(this);
      return false;
    });
  };
  ns.setup = function setup() {
    return ns.bindEvents();
  };
  return ns.setup;
});