class MigrateDragonflyImages < ActiveRecord::Migration
  def change
    if Refile.store.is_a? Refile::S3
      prefix = Refile.store.instance_variable_get(:@prefix)
      bucket = Refile.store.instance_variable_get(:@bucket)
      Smithy::Asset.where('file_id LIKE ?', 'uploads/%').each do |asset|
        new_file_id = asset.file_id.gsub(/([^a-z0-9]|(uploads\/)|(assets\/))/i, '')
        s3_object = bucket.object(asset.file_id)
        new_s3_object = bucket.object([*prefix, new_file_id].join('/'))

        if !s3_object.exists? && !new_s3_object.exists?
          say "[WARNING] Asset Not Found in S3, please find and move it manually, or remove the asset: ID=#{asset.id}, PATH=#{asset.file_id}";
          say "Refile expects it to be here: #{[*prefix, new_file_id].join('/')}", true
        elsif new_s3_object.exists?
          # File may have already been moved in S3
          s3_object.delete if s3_object.exists?
        else
          s3_object.move_to(new_s3_object)
        end
        asset.update_column(:file_id, new_file_id)
      end
    end

    Smithy::Asset.where(file_content_type: nil).each do |asset|
      asset.update_column(:file_content_type, asset.content_type)
    end
  end
end