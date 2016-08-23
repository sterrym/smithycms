# This migration comes from smithy (originally 20141113220013)
class ChangePageKeywordsToText < ActiveRecord::Migration
  def change
    change_column(:smithy_pages, :keywords, :text)
  end
end
