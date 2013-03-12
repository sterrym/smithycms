class RemoveDescriptionFromContentBlock < ActiveRecord::Migration
  def change
    remove_column :smithy_content_blocks, :description
  end
end
