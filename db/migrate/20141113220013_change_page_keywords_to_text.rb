class ChangePageKeywordsToText < ActiveRecord::Migration
  def change
    change_column(:smithy_pages, :keywords, :text)
  end
end
