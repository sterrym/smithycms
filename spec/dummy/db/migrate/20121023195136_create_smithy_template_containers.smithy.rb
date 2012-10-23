# This migration comes from smithy (originally 20121019145543)
class CreateSmithyTemplateContainers < ActiveRecord::Migration
  def change
    create_table :smithy_template_containers do |t|
      t.belongs_to :template
      t.string :name

      t.timestamps
    end
    add_index :smithy_template_containers, :template_id
  end
end
