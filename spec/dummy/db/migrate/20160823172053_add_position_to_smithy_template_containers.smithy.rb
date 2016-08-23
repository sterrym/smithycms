# This migration comes from smithy (originally 20131223145710)
class AddPositionToSmithyTemplateContainers < ActiveRecord::Migration
  def change
    add_column :smithy_template_containers, :position, :integer
  end
end
