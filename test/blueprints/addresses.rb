Address.blueprint do
  street1  { Forgery(:address).street_address }
  city     { Forgery(:address).city }
  state    { Forgery(:address).state }
  postcode { Forgery(:address).zip }
  country  { Forgery(:address).country }
end
