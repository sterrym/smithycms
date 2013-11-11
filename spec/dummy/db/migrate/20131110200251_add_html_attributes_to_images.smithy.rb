# This migration comes from smithy (originally 20130326191051)
class AddHtmlAttributesToImages < ActiveRecord::Migration
  def change
    add_column :smithy_images, :html_attributes, :string
  end
end
