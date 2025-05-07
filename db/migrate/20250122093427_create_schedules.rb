class CreateSchedules < ActiveRecord::Migration[8.0]
  def change
    create_table :schedules do |t|
      t.references :planning, null: false, foreign_key: true
      t.date :date

      t.timestamps
    end
  end
end
