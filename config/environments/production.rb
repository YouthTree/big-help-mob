BigHelpMob::Application.configure do
  config.cache_classes                     = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true
  config.log_level                         = :debug
  config.serve_static_assets               = false
  # config.cache_store                         = :redis_buddy_store
  # config.action_controller.asset_host        = "http://assets.example.com"
  # config.action_mailer.raise_delivery_errors = false
  # config.middleware.insert_after 'ActionDispatch::ShowExceptions', HoptoadNotifier::Rack
  # config.threadsafe!
end
