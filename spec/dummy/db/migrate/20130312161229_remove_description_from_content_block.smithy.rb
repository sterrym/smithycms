# This migration comes from smithy (originally 20130312161116)
class RemoveDescriptionFromContentBlock < ActiveRecord::Migration
  def change
    remove_column :smithy_content_blocks, :description
  end
end
