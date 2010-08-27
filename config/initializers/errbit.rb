if Settings.errbit.api_key? && defined?(HoptoadNotifier)
  HoptoadNotifier.configure do |config|
     config.api_key = Settings.errbit.api_key
     config.host    = Settings.errbit.fetch(:host, 'errbit.youthtree.org.au')
     config.port    = 80
  end
end