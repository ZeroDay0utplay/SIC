class CreatePlanningSubcontractors < ActiveRecord::Migration[8.0]
  def change
    create_table :planning_subcontractors do |t|
      t.references :schedule, null: false, foreign_key: true
      t.references :subcontractor, null: false, foreign_key: true
      t.integer :agent_needed
      t.boolean :include_contact
      t.boolean :send_email
      t.boolean :send_sms
      t.text :needs
      t.text :remark
      t.text :note
      t.float :rate_mission

      t.timestamps
    end
  end
end
