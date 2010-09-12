# Create a User.

sync, $stdout.sync = $stdout.sync, true
begin
  AttrAccessibleScoping.disabled do
    puts "Making Admin User."
    User.create! :login => "admin", :password => "monkey", :password_confirmation => "monkey", :email => "example@example.com", :admin => true
  
    print "Making Orgaisation: "
    10.times do
      print "."
      Organisation.create! :name        => Forgery(:name).company_name,
                           :description => Forgery(:lorem_ipsum).sentences(rand(4) + 3, :random => true),
                           :telephone   => (Forgery(:address).phone if rand(2) == 0),
                           :website     => ("http://#{Forgery(:internet).domain_name}/" if rand(2) == 0)
    end
    puts ""
  
  
    puts "Making Default Roles."
    Role.create! :name => "organizer"
    Role.create! :name => "captain"
    Role.create! :name => "sidekick"
  
    puts "Making default content sections."
    Content.create! :key => "home.introduction", :title => "Introduction", :content => ""
    Content.create! :key => "signup.introduction", :title => "Introduction", :content => ""
    Content.create! :key => "join-as.captain", :title => "Join As a Captain", :content => ""
    Content.create! :key => "join-as.sidekick", :title => "Join As a Sidekick", :content => ""
    
    Content.create! :key => "pages.about", :title => "About Big Help Mob", :content => ""
    Content.create! :key => "pages.privacy-policy", :title => "Our Privacy Policy", :content => ""
    Content.create! :key => "pages.terms-and-conditions", :title => "Terms and Conditions", :content => ""
    Content.create! :key => "pages.missions", :title => "Our Missions", :content => ""
    
    DynamicTemplate.create! :key => "notifications.role-approved.captain.default",  :content => "", :content_type => "html"
    DynamicTemplate.create! :key => "notifications.role-approved.sidekick.default", :content => "", :content_type => "html"
    DynamicTemplate.create! :key => "notifications.role-approved.captain.default",  :content => "", :content_type => "text"
    DynamicTemplate.create! :key => "notifications.role-approved.sidekick.default", :content => "", :content_type => "text"
    
  end
ensure
  $stdout.sync = sync
end