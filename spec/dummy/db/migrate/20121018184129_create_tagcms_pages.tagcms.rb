# This migration comes from tagcms (originally 20121018182146)
class CreateTagcmsPages < ActiveRecord::Migration
  def change
    create_table :tagcms_pages do |t|
      t.string :title, :null => false
      t.string :browser_title
      t.string :keywords
      t.string :description
      t.integer :cache_length
      t.datetime :published_at
      t.boolean :show_in_navigation
      t.string :permalink, :null => false
      t.string :path
      t.belongs_to :template
      t.belongs_to :parent
      t.integer :lft
      t.integer :rgt
      t.integer :depth

      t.timestamps
    end
    add_index :tagcms_pages, :template_id
    add_index :tagcms_pages, :parent_id
    add_index :tagcms_pages, :lft
    add_index :tagcms_pages, :rgt
    add_index :tagcms_pages, :permalink, :unique => true
  end
end
