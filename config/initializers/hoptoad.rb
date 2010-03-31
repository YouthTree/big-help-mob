if Settings.hoptoad.api_key?
  HoptoadNotifier.configure { |c| c.api_key = Settings.hoptoad.api_key }
end