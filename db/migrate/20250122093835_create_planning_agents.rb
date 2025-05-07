class CreatePlanningAgents < ActiveRecord::Migration[8.0]
  def change
    create_table :planning_agents do |t|
      t.references :schedule, null: false, foreign_key: true
      t.bigint :agent_id
      t.bigint :vehicle_id
      t.time :start_at
      t.time :finish_at

      t.timestamps
    end
  end
end
