# This migration comes from smithy (originally 20121105222537)
class CreateSmithyAssets < ActiveRecord::Migration
  def change
    create_table :smithy_assets do |t|
      t.string :name
      t.string :uploaded_file_url
      t.string :content_type
      t.string :file_uid
      t.string :file_name
      t.integer :file_size
      t.integer :file_width
      t.integer :file_height

      t.timestamps
    end
  end
end
