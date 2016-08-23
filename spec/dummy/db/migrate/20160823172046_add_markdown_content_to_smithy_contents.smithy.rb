# This migration comes from smithy (originally 20130115190505)
class AddMarkdownContentToSmithyContents < ActiveRecord::Migration
  def change
    add_column :smithy_contents, :markdown_content, :text
  end
end
