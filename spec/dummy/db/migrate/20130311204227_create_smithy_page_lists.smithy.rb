# This migration comes from smithy (originally 20130311203806)
class CreateSmithyPageLists < ActiveRecord::Migration
  def change
    create_table :smithy_page_lists do |t|
      t.belongs_to :parent
      t.belongs_to :page_template
      t.boolean :include_children
      t.integer :count
      t.string :sort

      t.timestamps
    end
    add_index :smithy_page_lists, :parent_id
    add_index :smithy_page_lists, :page_template_id
  end
end
