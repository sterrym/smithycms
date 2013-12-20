class AddContentToImages < ActiveRecord::Migration
  def change
    add_column :smithy_images, :content, :text
  end
end
