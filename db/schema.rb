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

ActiveRecord::Schema.define(:version => 20100301103448) do

  create_table "missions", :force => true do |t|
    t.string   "name",                                        :null => false
    t.text     "description",                                 :null => false
    t.integer  "user_id"
    t.integer  "ngo_id"
    t.date     "date",                                        :null => false
    t.time     "time",                                        :null => false
    t.string   "street1",                                     :null => false
    t.string   "street2"
    t.string   "city",                                        :null => false
    t.string   "state"
    t.string   "zip"
    t.decimal  "lat",         :precision => 15, :scale => 10
    t.decimal  "lng",         :precision => 15, :scale => 10
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
