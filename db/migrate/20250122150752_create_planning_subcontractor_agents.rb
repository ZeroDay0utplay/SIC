class CreatePlanningSubcontractorAgents < ActiveRecord::Migration[8.0]
  def change
    create_table :planning_subcontractor_agents do |t|
      t.references :planning_subcontractor, null: false, foreign_key: true
      t.references :subcontractor_agent, null: false, foreign_key: {to_table: :subcontractor_users}
      t.boolean :sms_delivered, default: false

      t.timestamps
    end
  end
end
