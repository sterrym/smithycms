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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150420150337) do

  create_table "smithy_assets", force: true do |t|
    t.string   "name"
    t.string   "uploaded_file_url"
    t.string   "content_type"
    t.string   "file_id"
    t.string   "file_filename"
    t.integer  "file_size"
    t.integer  "file_width"
    t.integer  "file_height"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file_content_type"
  end

  create_table "smithy_content_block_templates", force: true do |t|
    t.integer  "content_block_id"
    t.string   "name"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "smithy_content_block_templates", ["content_block_id"], name: "index_smithy_content_block_templates_on_content_block_id"

  create_table "smithy_content_blocks", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "smithy_contents", force: true do |t|
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "markdown_content"
  end

  create_table "smithy_images", force: true do |t|
    t.integer  "asset_id"
    t.string   "alternate_text"
    t.integer  "width"
    t.integer  "height"
    t.string   "image_scaling"
    t.string   "link_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "html_attributes"
    t.text     "content"
  end

  add_index "smithy_images", ["asset_id"], name: "index_smithy_images_on_asset_id"

  create_table "smithy_page_contents", force: true do |t|
    t.integer  "page_id"
    t.string   "label"
    t.string   "container"
    t.string   "content_block_type"
    t.integer  "content_block_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "content_block_template_id"
    t.boolean  "publishable",               default: false
  end

  add_index "smithy_page_contents", ["container"], name: "index_smithy_page_contents_on_container"
  add_index "smithy_page_contents", ["content_block_id"], name: "index_smithy_page_contents_on_content_block_id"
  add_index "smithy_page_contents", ["content_block_template_id"], name: "index_smithy_page_contents_on_content_block_template_id"
  add_index "smithy_page_contents", ["content_block_type"], name: "index_smithy_page_contents_on_content_block_type"
  add_index "smithy_page_contents", ["page_id"], name: "index_smithy_page_contents_on_page_id"
  add_index "smithy_page_contents", ["position"], name: "index_smithy_page_contents_on_position"

  create_table "smithy_page_lists", force: true do |t|
    t.integer  "parent_id"
    t.integer  "page_template_id"
    t.boolean  "include_children"
    t.integer  "count"
    t.string   "sort"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "smithy_page_lists", ["page_template_id"], name: "index_smithy_page_lists_on_page_template_id"
  add_index "smithy_page_lists", ["parent_id"], name: "index_smithy_page_lists_on_parent_id"

  create_table "smithy_pages", force: true do |t|
    t.string   "title",                             null: false
    t.string   "browser_title"
    t.string   "keywords"
    t.string   "description"
    t.integer  "cache_length",       default: 600
    t.datetime "published_at"
    t.boolean  "show_in_navigation", default: true
    t.string   "permalink",                         null: false
    t.string   "path",                              null: false
    t.integer  "template_id"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "external_link"
  end

  add_index "smithy_pages", ["lft"], name: "index_smithy_pages_on_lft"
  add_index "smithy_pages", ["parent_id"], name: "index_smithy_pages_on_parent_id"
  add_index "smithy_pages", ["path"], name: "index_smithy_pages_on_path", unique: true
  add_index "smithy_pages", ["rgt"], name: "index_smithy_pages_on_rgt"
  add_index "smithy_pages", ["template_id"], name: "index_smithy_pages_on_template_id"

  create_table "smithy_settings", force: true do |t|
    t.string   "name"
    t.text     "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "smithy_template_containers", force: true do |t|
    t.integer  "template_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
  end

  add_index "smithy_template_containers", ["template_id"], name: "index_smithy_template_containers_on_template_id"

  create_table "smithy_templates", force: true do |t|
    t.string   "name"
    t.string   "template_type", default: "template"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "smithy_users", force: true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string  "email",                          default: "",    null: false
    t.string  "encrypted_password", limit: 128, default: "",    null: false
    t.string  "login"
    t.boolean "smithy_admin",                   default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true

end
