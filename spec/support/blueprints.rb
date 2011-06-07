require 'forgery'

User.blueprint do
  login                 { "user#{sn}" }
  email                 { "#{object.login}@example.com" }
  password              { 'password' }
  password_confirmation { 'password' }
  first_name            { Forgery(:name).first_name }
  last_name             { Forgery(:name).last_name }
  origin                { User::ORIGIN_CHOICES.shuffle.first }
  date_of_birth         { 21.years.ago }
  gender                { User.gender_options_scope.choice }
end

Subscriber.blueprint do
  name  { "Example User #{sn}" }
  email { "example-#{sn}@example.com" }
end
