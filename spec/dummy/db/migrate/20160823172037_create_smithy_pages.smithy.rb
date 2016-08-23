# This migration comes from smithy (originally 20121018182146)
class CreateSmithyPages < ActiveRecord::Migration
  def change
    create_table :smithy_pages do |t|
      t.string :title, :null => false
      t.string :browser_title
      t.string :keywords
      t.string :description
      t.integer :cache_length
      t.datetime :published_at
      t.boolean :show_in_navigation
      t.string :permalink, :null => false
      t.string :path, :null => false
      t.belongs_to :template
      t.belongs_to :parent
      t.integer :lft
      t.integer :rgt
      t.integer :depth

      t.timestamps
    end
    add_index :smithy_pages, :template_id
    add_index :smithy_pages, :parent_id
    add_index :smithy_pages, :lft
    add_index :smithy_pages, :rgt
    add_index :smithy_pages, :path, :unique => true
  end
end
