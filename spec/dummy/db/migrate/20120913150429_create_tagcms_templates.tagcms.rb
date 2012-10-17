# This migration comes from tagcms (originally 20120911193140)
class CreateTagcmsTemplates < ActiveRecord::Migration
  def change
    create_table :tagcms_templates do |t|
      t.string :name
      t.string :template_type, :default => "template"
      t.text :content

      t.timestamps
    end
  end
end
