# This migration comes from smithy (originally 20120911203618)
class CreateSmithySettings < ActiveRecord::Migration
  def change
    create_table :smithy_settings do |t|
      t.string :name
      t.text :value

      t.timestamps
    end
  end
end
