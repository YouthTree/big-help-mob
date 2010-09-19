require 'forgery'

User.blueprint do
  login                 { "user#{sn}" }
  email                 { "#{object.login}@example.com" }
  password              { 'password' }
  password_confirmation { 'password' }
  first_name            { Forgery(:name).first_name }
  last_name             { Forgery(:name).last_name }
  origin                { User::ORIGIN_CHOICES.shuffle.first }
end