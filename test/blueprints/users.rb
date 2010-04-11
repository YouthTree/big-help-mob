User.blueprint do
  login                 { Forgery(:internet).user_name }
  email                 { Forgery(:internet).email_address }
  first_name            { Forgery(:name).last_name }
  last_name             { Forgery(:name).first_name }
  display_name          { "#{first_name} #{last_name}".strip }
  date_of_birth         { 15.years.ago.to_date - rand(10 * 365)}
  phone                 { ["####-###-###", "##-####-####", "##########", "#### ####"].rand.to_numbers }
  postcode              { rand(1000) + 6000 }
  password              { Forgery(:lorem_ipsum).words(2 + rand(4), :random => true) }
  password_confirmation { password }
  admin         false
end
