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

ActiveRecord::Schema.define(:version => 20090408201656) do

  create_table "options", :force => true do |t|
    t.string   "key",        :limit => 32
    t.text     "value"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "options", ["key"], :name => "index_options_on_key"
  add_index "options", ["user_id"], :name => "index_options_on_user_id"

  create_table "pages", :force => true do |t|
    t.string   "title"
    t.string   "slug",         :limit => 128
    t.text     "content"
    t.integer  "user_id"
    t.integer  "status",                      :default => 0
    t.datetime "published_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pages", ["slug"], :name => "index_pages_on_slug"
  add_index "pages", ["status"], :name => "index_pages_on_status"

end
