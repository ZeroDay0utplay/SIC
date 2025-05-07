class CreateMaterials < ActiveRecord::Migration[8.0]
  def change
    create_table :materials do |t|
      t.string :type
      t.text :notes
      t.string :name
      t.string :reference
      t.string :serial_number
      t.boolean :is_active
      t.string :picture
      t.bigint :company_id

      t.timestamps
    end
  end
end
