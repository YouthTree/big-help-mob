require 'formtastic'
ActionView::Base.send :include, Formtastic::SemanticFormHelper

Formtastic::SemanticFormBuilder.include_blank_for_select_by_default = true
Formtastic::SemanticFormBuilder.required_string                     = proc { ::Formtastic::I18n.t(:required).html_safe }
Formtastic::SemanticFormBuilder.optional_string                     = proc { ::Formtastic::I18n.t(:optional).html_safe }
Formtastic::SemanticFormBuilder.i18n_lookups_by_default             = true
Formtastic::SemanticFormHelper.builder                              = FormtasticWithButtonsBuilder
