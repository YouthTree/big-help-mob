Rails.application.config.session_store :cookie_store, :key => Settings.fetch(:session_key, 'BigHelpMob-Session')
Rails.application.config.secret_token = Settings.secret_key

