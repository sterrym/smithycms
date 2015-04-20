class UpdateToRefile < ActiveRecord::Migration
  def change
    rename_column :smithy_assets, :file_uid, :file_id
    rename_column :smithy_assets, :file_name, :file_filename
    add_column :smithy_assets, :file_content_type, :string
  end
end
