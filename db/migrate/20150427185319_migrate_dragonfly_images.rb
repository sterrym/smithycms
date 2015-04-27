class MigrateDragonflyImages < ActiveRecord::Migration
  def change
    prefix = Refile.store.instance_variable_get(:@prefix)
    bucket = Refile.store.instance_variable_get(:@bucket)
    Smithy::Asset.each do |asset|
      new_file_id = asset.file_id.gsub(/[^a-z0-9]/i, '')
      asset.update_column(:file_id, new_file_id)
      bucket.objects[asset.file_id].move_to([*prefix, new_file_id].join('/'))
    end
  end
end
