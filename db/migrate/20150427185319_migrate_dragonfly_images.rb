class MigrateDragonflyImages < ActiveRecord::Migration
  def change
    prefix = Refile.store.instance_variable_get(:@prefix)
    bucket = Refile.store.instance_variable_get(:@bucket)
    Smithy::Asset.where('file_id LIKE ?', 'uploads/%').each do |asset|
      new_file_id = asset.file_id.gsub(/[^a-z0-9]/i, '')
      bucket.objects[asset.file_id].move_to([*prefix, new_file_id].join('/'))
      asset.update_column(:file_id, new_file_id)
    end
  end
end
