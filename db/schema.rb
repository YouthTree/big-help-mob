# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100328065152) do

  create_table "addresses", :force => true do |t|
    t.integer  "addressable_id"
    t.string   "addressable_type"
    t.string   "street1"
    t.string   "street2"
    t.string   "city"
    t.string   "state"
    t.string   "postcode"
    t.string   "country"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "lat",              :precision => 15, :scale => 10
    t.decimal  "lng",              :precision => 15, :scale => 10
  end

  add_index "addresses", ["addressable_id", "addressable_type"], :name => "index_addresses_on_addressable_id_and_addressable_type"

  create_table "captain_applications", :force => true do |t|
    t.text     "reason_why"
    t.text     "offers"
    t.boolean  "has_first_aid_cert"
    t.boolean  "accepted"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "contents", :force => true do |t|
    t.string   "title"
    t.string   "key"
    t.string   "type"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mission_participations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "mission_id"
    t.string   "state"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "pickup_id"
    t.text     "raw_answers"
  end

  create_table "mission_pickups", :force => true do |t|
    t.integer  "mission_id"
    t.integer  "pickup_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mission_questions", :force => true do |t|
    t.integer  "mission_id"
    t.string   "name"
    t.boolean  "required"
    t.string   "question_type"
    t.text     "metadata"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "missions", :force => true do |t|
    t.string   "name",            :null => false
    t.text     "description",     :null => false
    t.integer  "user_id"
    t.integer  "organisation_id"
    t.datetime "occurs_at",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state"
  end

  create_table "organisations", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "telephone"
    t.string   "website"
    t.string   "permalink"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pickups", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "questions", :force => true do |t|
    t.boolean  "visible",    :default => false, :null => false
    t.integer  "position"
    t.text     "question"
    t.text     "answer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rpx_identifiers", :force => true do |t|
    t.string   "identifier",    :null => false
    t.string   "provider_name"
    t.integer  "user_id",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rpx_identifiers", ["identifier"], :name => "index_rpx_identifiers_on_identifier", :unique => true
  add_index "rpx_identifiers", ["user_id"], :name => "index_rpx_identifiers_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.string   "email"
    t.integer  "login_count"
    t.datetime "last_request_at"
    t.datetime "last_login_at"
    t.datetime "current_login_at"
    t.string   "last_login_ip"
    t.string   "current_login_ip"
    t.string   "display_name"
    t.boolean  "admin"
    t.string   "first_name"
    t.string   "last_name"
    t.date     "date_of_birth"
    t.string   "phone"
    t.integer  "postcode"
    t.text     "allergies"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "current_role_id"
    t.string   "origin"
    t.string   "perishable_token",  :default => "", :null => false
  end

  add_index "users", ["perishable_token"], :name => "index_users_on_perishable_token"

end
