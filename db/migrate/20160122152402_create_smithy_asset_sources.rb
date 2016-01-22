class CreateSmithyAssetSources < ActiveRecord::Migration
  def change
    create_table :smithy_asset_sources do |t|
      t.string :name

      t.timestamps
    end

    default_source = Smithy::AssetSource.create(name: "Default")

    add_reference :smithy_assets, :asset_source, index: true, default: default_source.id, null: false
  end
end
