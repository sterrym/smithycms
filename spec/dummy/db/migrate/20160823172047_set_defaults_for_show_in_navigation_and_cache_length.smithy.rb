# This migration comes from smithy (originally 20130123170918)
class SetDefaultsForShowInNavigationAndCacheLength < ActiveRecord::Migration
  def change
    change_column_default(:smithy_pages, :show_in_navigation, true)
    change_column_default(:smithy_pages, :cache_length, 600)
  end
end
