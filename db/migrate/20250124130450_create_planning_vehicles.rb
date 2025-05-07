class CreatePlanningVehicles < ActiveRecord::Migration[8.0]
  def change
    create_table :planning_vehicles do |t|
      t.references :planning, null: false, foreign_key: true
      t.references :vehicle, null: false, foreign_key: true

      t.timestamps
    end
  end
end
