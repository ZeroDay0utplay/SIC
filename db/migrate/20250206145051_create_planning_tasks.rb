class CreatePlanningTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :planning_tasks do |t|
      t.references :prestation, null: false, foreign_key: true
      t.references :planning, null: false, foreign_key: true
      t.time :started_at
      t.time :finished_at
      t.text :description
      t.date :date
      t.integer :state # enum
      t.bigint :user_id

      t.timestamps
    end
  end
end
