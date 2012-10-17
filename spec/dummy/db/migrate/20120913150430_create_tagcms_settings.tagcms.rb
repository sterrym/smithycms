# This migration comes from tagcms (originally 20120911203618)
class CreateTagcmsSettings < ActiveRecord::Migration
  def change
    create_table :tagcms_settings do |t|
      t.string :name
      t.text :value

      t.timestamps
    end
  end
end
