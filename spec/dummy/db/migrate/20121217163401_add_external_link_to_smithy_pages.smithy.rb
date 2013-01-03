# This migration comes from smithy (originally 20121127205022)
class AddExternalLinkToSmithyPages < ActiveRecord::Migration
  def change
    add_column :smithy_pages, :external_link, :string
  end
end
