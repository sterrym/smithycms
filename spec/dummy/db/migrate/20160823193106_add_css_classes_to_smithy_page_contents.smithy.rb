# This migration comes from smithy (originally 20160819164547)
class AddCssClassesToSmithyPageContents < ActiveRecord::Migration
  def change
    add_column :smithy_page_contents, :css_classes, :string
  end
end
