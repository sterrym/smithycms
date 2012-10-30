class CreateSmithyContents < ActiveRecord::Migration
  def change
    create_table :smithy_contents do |t|
      t.text :content

      t.timestamps
    end
  end
end
