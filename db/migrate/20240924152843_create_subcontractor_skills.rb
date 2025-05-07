class CreateSubcontractorSkills < ActiveRecord::Migration[7.1]
  def change
    create_table :subcontractor_skills do |t|
      t.references :subcontractor, null: false, foreign_key: true
      t.references :skill, null: false, foreign_key: true

      t.timestamps
    end
  end
end
