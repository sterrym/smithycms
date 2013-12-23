class AddPositionToSmithyTemplateContainers < ActiveRecord::Migration
  def change
    add_column :smithy_template_containers, :position, :integer
  end
end
