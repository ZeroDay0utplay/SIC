class CreatePlanningReportPhotos < ActiveRecord::Migration[8.0]
  def change
    create_table :planning_report_photos do |t|
      t.references :planning, null: false, foreign_key: true
      t.integer :position
      t.bigint :parent_id
      t.string :photo

      t.timestamps
    end
  end
end
