# This migration comes from smithy (originally 20121024213357)
class CreateSmithyContentBlocks < ActiveRecord::Migration
  def change
    create_table :smithy_content_blocks do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
