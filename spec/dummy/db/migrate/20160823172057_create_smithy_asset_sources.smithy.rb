# This migration comes from smithy (originally 20160122152402)
class CreateSmithyAssetSources < ActiveRecord::Migration
  def change
    create_table :smithy_asset_sources do |t|
      t.string :name

      t.timestamps
    end

    add_reference :smithy_assets, :asset_source, index: true

    default_source = Smithy::AssetSource.find_or_create_by(name: "Default")
    Smithy::Asset.where(asset_source: nil).update_all(asset_source_id: default_source.id)
  end
end
