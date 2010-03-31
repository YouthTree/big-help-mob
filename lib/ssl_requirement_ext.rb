module SslRequirementExt
  
  def self.included(parent)
    (class << parent; self; end).class_eval do
      include ClassMethods
      alias_method_chain :ssl_required, :env_check
      alias_method_chain :ssl_allowed,  :env_check
    end
  end
  
  module ClassMethods
    
    def ssl_required_with_env_check(*actions)
      ssl_required_without_env_check(*actions) if Settings.ssl?
    end

    def ssl_allowed_with_env_check(*actions)
      ssl_allowed_without_env_check(*actions) if Settings.ssl?
    end
    
  end
  
end