ObserverLoader.load!

ActionDispatch::Callbacks.to_prepare(:observer_loader) do
  ObserverLoader.load!
end

# Nullify the old loader
ActionDispatch::Callbacks.to_prepare(:activerecord_instantiate_observers) do
end