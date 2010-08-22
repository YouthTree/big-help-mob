BHM.withNS 'Admin.EmailEditor', (ns) ->
  
  ns.participationSelector  = '#participations-filter'
  ns.typeSelector           = 'select#email_scope_type'
  ns.previewSectionSelector = 'a.preview-email-section'
  ns.confirmedSelector      = '#email_confirmed'
  ns.confirmedFieldset      = 'fieldset#email-confirmation'
  
  ns.setButtonText = (text) ->
    $("#email_submit").text text
  
  ns.hideConfirmation = ->
    $(ns.confirmedSelector).removeAttr "check"
    $(ns.confirmedFieldset).hide()
    ns.setButtonText "Preview and Confirm"
    
  ns.removePreviewFor = (field) ->
    $("#preview-of-#{field}").hide()
    ns.hideConfirmation()
  
  ns.hideParticipationFilter = -> $(ns.participationSelector).hide()
  
  ns.showParticipationFilter = -> $(ns.participationSelector).show()
  
  ns.shouldShowParticipationFilter = ->
    $(ns.typeSelector).val() is "participations"
    
  ns.toggleParticipationFilter = ->
    if ns.shouldShowParticipationFilter()
      ns.showParticipationFilter()
    else
      ns.hideParticipationFilter()
      
  ns.showPreviewFor = (scope) ->
    scope = $ scope
    $.facybox {div: scope.attr("href")}, "email-section-preview"
  
  ns.bindEvents = ->
    $(ns.typeSelector).change(-> ns.toggleParticipationFilter()).change()
    $("#email_subject").change -> ns.removePreviewFor "subject"
    $("#email_text_content").change -> ns.removePreviewFor "text-content"
    $(ns.previewSectionSelector).click ->
      ns.showPreviewFor @
      false
  
  ns.setup = -> ns.bindEvents()
    