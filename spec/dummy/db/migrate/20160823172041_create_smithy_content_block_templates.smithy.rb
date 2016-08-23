# This migration comes from smithy (originally 20121025011733)
class CreateSmithyContentBlockTemplates < ActiveRecord::Migration
  def change
    create_table :smithy_content_block_templates do |t|
      t.belongs_to :content_block
      t.string :name
      t.text :content

      t.timestamps
    end
    add_index :smithy_content_block_templates, :content_block_id
  end
end
