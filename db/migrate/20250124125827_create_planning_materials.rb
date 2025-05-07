class CreatePlanningMaterials < ActiveRecord::Migration[8.0]
  def change
    create_table :planning_materials do |t|
      t.integer :quantity, null: false, default: 1
      t.references :planning, null: false, foreign_key: true
      t.references :material, null: false, foreign_key: true

      t.timestamps
    end
  end
end
