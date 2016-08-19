class AddCssClassesToSmithyPageContents < ActiveRecord::Migration
  def change
    add_column :smithy_page_contents, :css_classes, :string
  end
end
