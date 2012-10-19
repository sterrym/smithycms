# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121019160538) do

  create_table "tagcms_page_contents", :force => true do |t|
    t.integer  "page_id"
    t.string   "container"
    t.string   "content_block_type"
    t.integer  "content_block_id"
    t.integer  "position"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "tagcms_page_contents", ["container"], :name => "index_tagcms_page_contents_on_container"
  add_index "tagcms_page_contents", ["content_block_id"], :name => "index_tagcms_page_contents_on_content_block_id"
  add_index "tagcms_page_contents", ["content_block_type"], :name => "index_tagcms_page_contents_on_content_block_type"
  add_index "tagcms_page_contents", ["page_id"], :name => "index_tagcms_page_contents_on_page_id"
  add_index "tagcms_page_contents", ["position"], :name => "index_tagcms_page_contents_on_position"

  create_table "tagcms_pages", :force => true do |t|
    t.string   "title",              :null => false
    t.string   "browser_title"
    t.string   "keywords"
    t.string   "description"
    t.integer  "cache_length"
    t.datetime "published_at"
    t.boolean  "show_in_navigation"
    t.string   "permalink",          :null => false
    t.string   "path"
    t.integer  "template_id"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "tagcms_pages", ["lft"], :name => "index_tagcms_pages_on_lft"
  add_index "tagcms_pages", ["parent_id"], :name => "index_tagcms_pages_on_parent_id"
  add_index "tagcms_pages", ["permalink"], :name => "index_tagcms_pages_on_permalink", :unique => true
  add_index "tagcms_pages", ["rgt"], :name => "index_tagcms_pages_on_rgt"
  add_index "tagcms_pages", ["template_id"], :name => "index_tagcms_pages_on_template_id"

  create_table "tagcms_settings", :force => true do |t|
    t.string   "name"
    t.text     "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tagcms_template_containers", :force => true do |t|
    t.integer  "template_id"
    t.string   "name"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "tagcms_template_containers", ["template_id"], :name => "index_tagcms_template_containers_on_template_id"

  create_table "tagcms_templates", :force => true do |t|
    t.string   "name"
    t.string   "template_type", :default => "template"
    t.text     "content"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
  end

end
