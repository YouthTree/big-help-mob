# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :mission do |f|
  f.name "MyString"
  f.description "MyText"
  f.ngo_id 1
  f.date "2010-03-01"
  f.time "2010-03-01 18:34:49"
  f.street1 "MyString"
  f.street2 "MyString"
  f.city "MyString"
  f.state "MyString"
  f.zip "MyString"
  f.lat "9.99"
  f.lng "9.99"
end
