class CreatePlanningContacts < ActiveRecord::Migration[8.0]
  def change
    create_table :planning_contacts do |t|
      t.references :planning, null: false, foreign_key: true
      t.references :contact, null: false, foreign_key: true
      t.integer :contact_type

      t.timestamps
    end
  end
end
