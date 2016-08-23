# This migration comes from smithy (originally 20131003210228)
class AddPublishableToSmithyPageContents < ActiveRecord::Migration
  def up
    add_column :smithy_page_contents, :publishable, :boolean, :default => false
    Smithy::PageContent.reset_column_information
    Smithy::PageContent.all.each{|pc| pc.update_attribute(:publishable, true) }
  end

  def down
    remove_column :smithy_page_contents, :publishable
  end
end
