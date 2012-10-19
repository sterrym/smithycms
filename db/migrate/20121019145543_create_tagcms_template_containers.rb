class CreateTagcmsTemplateContainers < ActiveRecord::Migration
  def change
    create_table :tagcms_template_containers do |t|
      t.belongs_to :template
      t.string :name

      t.timestamps
    end
    add_index :tagcms_template_containers, :template_id
  end
end
