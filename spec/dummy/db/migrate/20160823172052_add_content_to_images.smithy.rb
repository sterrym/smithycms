# This migration comes from smithy (originally 20131220160755)
class AddContentToImages < ActiveRecord::Migration
  def change
    add_column :smithy_images, :content, :text
  end
end
