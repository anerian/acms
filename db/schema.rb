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

ActiveRecord::Schema.define(:version => 20090505195058) do

  create_table "assets", :force => true do |t|
    t.string   "key"
    t.string   "ext"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assets", ["key"], :name => "index_assets_on_key"

  create_table "assets_pages", :id => false, :force => true do |t|
    t.integer "asset_id"
    t.integer "page_id"
  end

  add_index "assets_pages", ["asset_id", "page_id"], :name => "index_assets_pages_on_asset_id_and_page_id"

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.integer  "position"
    t.integer  "children_count"
    t.integer  "ancestors_count"
    t.integer  "descendants_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories_pages", :id => false, :force => true do |t|
    t.integer "category_id", :null => false
    t.integer "page_id",     :null => false
  end

  add_index "categories_pages", ["category_id", "page_id"], :name => "index_categories_pages_on_category_id_and_page_id", :unique => true

  create_table "comments", :force => true do |t|
    t.string   "title",            :limit => 50, :default => ""
    t.string   "comment",                        :default => ""
    t.datetime "created_at",                                     :null => false
    t.integer  "commentable_id",                 :default => 0,  :null => false
    t.string   "commentable_type", :limit => 15, :default => "", :null => false
    t.integer  "user_id",                        :default => 0,  :null => false
  end

  add_index "comments", ["user_id"], :name => "fk_comments_user"

  create_table "options", :force => true do |t|
    t.string "key",   :limit => 32, :null => false
    t.text   "value",               :null => false
  end

  add_index "options", ["key"], :name => "index_options_on_key"

  create_table "pages", :force => true do |t|
    t.string   "title"
    t.string   "slug",         :limit => 128
    t.text     "content"
    t.integer  "user_id"
    t.integer  "parent_id"
    t.integer  "status",                      :default => 0
    t.datetime "published_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pages", ["slug"], :name => "index_pages_on_slug"
  add_index "pages", ["status"], :name => "index_pages_on_status"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type"], :name => "index_taggings_on_taggable_id_and_taggable_type"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                              :null => false
    t.string   "crypted_password",                   :null => false
    t.string   "password_salt",                      :null => false
    t.string   "persistence_token",                  :null => false
    t.string   "single_access_token",                :null => false
    t.string   "perishable_token",                   :null => false
    t.integer  "login_count",         :default => 0, :null => false
    t.integer  "failed_login_count",  :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.boolean  "google"
    t.string   "name"
  end

end
