# This migration comes from smithy (originally 20121019160426)
class CreateSmithyPageContents < ActiveRecord::Migration
  def change
    create_table :smithy_page_contents do |t|
      t.belongs_to :page
      t.string :label
      t.string :container
      t.string :content_block_type
      t.integer :content_block_id
      t.integer :position

      t.timestamps
    end
    add_index :smithy_page_contents, :page_id
    add_index :smithy_page_contents, :container
    add_index :smithy_page_contents, :content_block_type
    add_index :smithy_page_contents, :content_block_id
    add_index :smithy_page_contents, :position
  end
end
