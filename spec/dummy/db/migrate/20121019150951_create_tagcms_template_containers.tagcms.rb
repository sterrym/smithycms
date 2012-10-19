# This migration comes from tagcms (originally 20121019145543)
class CreateTemplateContainers < ActiveRecord::Migration
  def change
    create_table :tagcms_template_containers do |t|
      t.belongs_to :template
      t.string :name

      t.timestamps
    end
    add_index :tagcms_template_containers, :template_id
  end
end
