class CreateVehicles < ActiveRecord::Migration[8.0]
  def change
    create_table :vehicles do |t|
      t.string :license_plate
      t.string :brand
      t.string :model
      t.string :color
      t.date :last_technical_inspection_date
      t.boolean :insured
      t.date :insurance_end_date
      t.boolean :in_circulation
      t.text :comments
      t.bigint :company_id

      t.timestamps
    end
  end
end
