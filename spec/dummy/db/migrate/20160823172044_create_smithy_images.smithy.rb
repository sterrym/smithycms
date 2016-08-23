# This migration comes from smithy (originally 20121115215053)
class CreateSmithyImages < ActiveRecord::Migration
  def change
    create_table :smithy_images do |t|
      t.belongs_to :asset
      t.string :alternate_text
      t.integer :width
      t.integer :height
      t.string :image_scaling
      t.string :link_url

      t.timestamps
    end
    add_index :smithy_images, :asset_id
  end
end
