class QueueManager
  
  def self.enqueue(klass, *args)
    offline? ? klass.perform(*args) : Resque.enqueue(klass, *args)
  end
  
  def self.offline?
    Rails.env.development? || Rails.env.testing?
  end
  
end