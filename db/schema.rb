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

ActiveRecord::Schema.define(:version => 20100611093351) do

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

  add_index "addresses", ["addressable_id", "addressable_type", "lat", "lng"], :name => "idx_addresses_on_addressable_and_location"
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

  add_index "captain_applications", ["user_id"], :name => "index_captain_applications_on_user_id"

  create_table "contents", :force => true do |t|
    t.string   "title"
    t.string   "key"
    t.string   "type"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contents", ["key"], :name => "index_contents_on_key"

  create_table "dynamic_templates", :force => true do |t|
    t.string   "key"
    t.string   "template_type"
    t.string   "content_type"
    t.text     "parts"
    t.integer  "parent_id"
    t.string   "parent_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dynamic_templates", ["key", "template_type", "content_type"], :name => "idx_dynamic_templates_on_keys"
  add_index "dynamic_templates", ["key", "template_type"], :name => "index_dynamic_templates_on_key_and_template_type"
  add_index "dynamic_templates", ["key"], :name => "index_dynamic_templates_on_key"
  add_index "dynamic_templates", ["template_type"], :name => "index_dynamic_templates_on_template_type"

  create_table "flickr_photos", :force => true do |t|
    t.integer  "farm"
    t.string   "title"
    t.string   "isprimary"
    t.string   "flickr_id"
    t.string   "server"
    t.string   "secret"
    t.integer  "mission_id"
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
    t.text     "comment"
  end

  add_index "mission_participations", ["mission_id", "role_id"], :name => "index_mission_participations_on_mission_id_and_role_id"
  add_index "mission_participations", ["mission_id"], :name => "index_mission_participations_on_mission_id"
  add_index "mission_participations", ["user_id", "mission_id", "role_id"], :name => "idx_mission_participations_on_all_relations"
  add_index "mission_participations", ["user_id", "mission_id"], :name => "index_mission_participations_on_user_id_and_mission_id"
  add_index "mission_participations", ["user_id", "role_id"], :name => "index_mission_participations_on_user_id_and_role_id"
  add_index "mission_participations", ["user_id"], :name => "index_mission_participations_on_user_id"

  create_table "mission_pickups", :force => true do |t|
    t.integer  "mission_id"
    t.integer  "pickup_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "pickup_at"
    t.text     "comment"
  end

  add_index "mission_pickups", ["mission_id", "pickup_id"], :name => "index_mission_pickups_on_mission_id_and_pickup_id"

  create_table "mission_questions", :force => true do |t|
    t.integer  "mission_id"
    t.string   "name"
    t.string   "question_type"
    t.text     "metadata"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "default_value"
    t.string   "required_by_role"
    t.string   "viewable_by_role", :default => "all"
  end

  add_index "mission_questions", ["mission_id"], :name => "index_mission_questions_on_mission_id"

  create_table "missions", :force => true do |t|
    t.string   "name",                                   :null => false
    t.text     "description",                            :null => false
    t.integer  "user_id"
    t.integer  "organisation_id"
    t.datetime "occurs_at",                              :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state"
    t.string   "cached_slug"
    t.integer  "minimum_sidekick_age"
    t.integer  "maximum_sidekick_age"
    t.integer  "minimum_captain_age"
    t.integer  "maximum_captain_age"
    t.string   "address_title"
    t.boolean  "captain_signup_open",  :default => true
    t.boolean  "sidekick_signup_open", :default => true
  end

  add_index "missions", ["cached_slug"], :name => "index_missions_on_cached_slug"
  add_index "missions", ["organisation_id"], :name => "index_missions_on_organisation_id"
  add_index "missions", ["state"], :name => "index_missions_on_state"
  add_index "missions", ["user_id"], :name => "index_missions_on_user_id"

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
    t.boolean  "visible",                  :default => false, :null => false
    t.integer  "position"
    t.text     "question"
    t.text     "answer"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "show_on_mission_page",     :default => false
    t.boolean  "show_on_sidekick_section", :default => false
    t.boolean  "show_on_captain_section",  :default => false
  end

  add_index "questions", ["visible", "position"], :name => "index_questions_on_visible_and_position"
  add_index "questions", ["visible"], :name => "index_questions_on_visible"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "rpx_identifiers", :force => true do |t|
    t.string   "identifier",    :null => false
    t.string   "provider_name"
    t.integer  "user_id",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rpx_identifiers", ["identifier"], :name => "index_rpx_identifiers_on_identifier", :unique => true
  add_index "rpx_identifiers", ["user_id"], :name => "index_rpx_identifiers_on_user_id"

  create_table "slugs", :force => true do |t|
    t.string   "scope"
    t.string   "slug"
    t.integer  "record_id"
    t.datetime "created_at"
  end

  add_index "slugs", ["scope", "record_id", "created_at"], :name => "index_slugs_on_scope_and_record_id_and_created_at"
  add_index "slugs", ["scope", "record_id"], :name => "index_slugs_on_scope_and_record_id"
  add_index "slugs", ["scope", "slug", "created_at"], :name => "index_slugs_on_scope_and_slug_and_created_at"
  add_index "slugs", ["scope", "slug"], :name => "index_slugs_on_scope_and_slug"

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
    t.string   "perishable_token",                                  :default => "", :null => false
    t.decimal  "postcode_lat",      :precision => 15, :scale => 10
    t.decimal  "postcode_lng",      :precision => 15, :scale => 10
    t.string   "cached_slug"
    t.text     "comment"
  end

  add_index "users", ["admin"], :name => "index_users_on_admin"
  add_index "users", ["cached_slug"], :name => "index_users_on_cached_slug"
  add_index "users", ["current_role_id"], :name => "index_users_on_current_role_id"
  add_index "users", ["login"], :name => "index_users_on_login"
  add_index "users", ["perishable_token"], :name => "index_users_on_perishable_token"
  add_index "users", ["persistence_token"], :name => "index_users_on_persistence_token"

end
