# This migration comes from smithy (originally 20121101151822)
class AddContentBlockTemplateIdToPageContents < ActiveRecord::Migration
  def change
    add_column :smithy_page_contents, :content_block_template_id, :integer
    add_index :smithy_page_contents, :content_block_template_id
  end
end
