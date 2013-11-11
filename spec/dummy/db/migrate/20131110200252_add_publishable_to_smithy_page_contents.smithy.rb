# This migration comes from smithy (originally 20131003210228)
class AddPublishableToSmithyPageContents < ActiveRecord::Migration
  def change
    add_column :smithy_page_contents, :publishable, :boolean, :default => false
  end
end
