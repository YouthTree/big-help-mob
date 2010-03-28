module ActionMailerNicerI18nSubjects

  protected
  
  def subject_vars(interpolation = nil)
    (@subject_vars ||= {}).tap do |hash|
      hash.merge!(interpolation) if interpolation.present?
    end
  end
  
  def default_i18n_subject
    mailer_scope = self.class.mailer_name.gsub('/', '.')
    options = {:scope => [:actionmailer, mailer_scope, action_name], :default => action_name.humanize}.merge(subject_vars.symbolize_keys)
    I18n.t(:subject, options)
  end
  
end