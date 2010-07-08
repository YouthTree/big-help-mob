BigHelpMob::Application.configure do
  config.cache_classes                     = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true
  config.log_level                         = :debug
  config.serve_static_assets               = true
end
