class AddExternalLinkToSmithyPages < ActiveRecord::Migration
  def change
    add_column :smithy_pages, :external_link, :string
  end
end
