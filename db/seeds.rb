# Create a User.

sync, $stdout.sync = $stdout.sync, true
begin
  puts "Making Admin User."
  User.create!({:login => "admin", :password => "monkey", :password_confirmation => "monkey", :email => "example@example.com", :admin => true}.trust)
  
  print "Making Orgaisation: "
  10.times do
    print "."
    Organisation.create!({:name        => Forgery(:name).company_name,
                          :description => Forgery(:lorem_ipsum).sentences(rand(4) + 3, :random => true),
                          :telephone   => (Forgery(:address).phone if rand(2) == 0),
                          :website     => ("http://#{Forgery(:internet).domain_name}/" if rand(2) == 0)}.trust)
  end
  puts ""
  
  
  puts "Making Default Roles."
  Role.create!({:name => "organizer"}.trust)
  Role.create!({:name => "captain"}.trust)
  Role.create!({:name => "sidekick"}.trust)
  
  puts "Making default content sections."
  Content.create!({:name => "home.introduction", :title => "Introduction", :content => ""}.trust)
  Content.create!({:name => "signup.introduction", :title => "Introduction", :content => ""}.trust)
  
ensure
  $stdout.sync = sync
end