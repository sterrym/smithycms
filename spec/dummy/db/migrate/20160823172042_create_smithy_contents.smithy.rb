# This migration comes from smithy (originally 20121029175812)
class CreateSmithyContents < ActiveRecord::Migration
  def change
    create_table :smithy_contents do |t|
      t.text :content

      t.timestamps
    end
  end
end
