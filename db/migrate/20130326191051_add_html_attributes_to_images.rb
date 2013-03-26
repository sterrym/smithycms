class AddHtmlAttributesToImages < ActiveRecord::Migration
  def change
    add_column :images, :html_attributes, :string
  end
end
