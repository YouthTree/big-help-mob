module SubscribersHelper
  
  def show_subscription_button(text = 'Subscribe to our Mailing List')
    link_to text, new_subscriber_path, :class => 'subscribe-to-mailing-list'
  end
  
end
