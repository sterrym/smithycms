class MigrateDragonflyImages < ActiveRecord::Migration
  def change
    prefix = Refile.store.instance_variable_get(:@prefix)
    bucket = Refile.store.instance_variable_get(:@bucket)
    Smithy::Asset.where('file_id LIKE ?', 'uploads/%').each do |asset|
      new_file_id = asset.file_id.gsub(/[^a-z0-9]/i, '')
      begin
        bucket.objects[asset.file_id].move_to([*prefix, new_file_id].join('/'))
        asset.update_column(:file_id, new_file_id)
      rescue AWS::S3::Errors::NoSuchKey
        # File may have already been moved in S3
        asset.update_column(:file_id, new_file_id) if bucket.objects[[*prefix, new_file_id].join('/')].exists?
      end
    end

    Smithy::Asset.where(file_content_type: nil).each do |asset|
      asset.update_column(:file_content_type, asset.content_type)
    end
  end
end
