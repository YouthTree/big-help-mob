class ObserverLoader
  
  def self.observers
    Dir[Rails.root.join("app", "observers", "*.rb")].map { |f| File.basename(f, ".rb").to_sym }
  end
  
  def self.update_observer_list!
    ActiveRecord::Base.observers = self.observers
  end
  
  def self.load!
    self.update_observer_list!
    ActiveRecord::Base.instantiate_observers
  end
  
end