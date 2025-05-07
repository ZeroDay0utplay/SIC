class CreatePointingInternals < ActiveRecord::Migration[8.0]
  def change
    create_table :pointing_internals do |t|
      t.references :planning_agent, null: false, foreign_key: true
      t.time :started_on
      t.time :finished_on
      t.boolean :is_valide
      t.float :rate_lunch
      t.float :overtime
      t.bigint :validate_by
      t.bigint :company_id

      t.timestamps
    end
  end
end
