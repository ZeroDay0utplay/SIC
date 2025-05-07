class CreateAbsences < ActiveRecord::Migration[7.1]
  def change
    create_table :absences do |t|
      t.bigint :user_id
      t.date :date_start
      t.date :date_end
      t.text :motif
      t.integer :type_absence, default: 0
      t.string :document
      t.integer :state, default: 0

      t.timestamps
    end
  end
end
