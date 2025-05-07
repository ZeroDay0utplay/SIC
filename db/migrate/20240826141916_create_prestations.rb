class CreatePrestations < ActiveRecord::Migration[7.1]
  def change
    create_table :prestations do |t|
      t.string :name
      t.text :description
      t.text :remark
      t.string :alias
      t.decimal :price
      t.string :unity
      t.integer :type_prestation
      t.integer :state
      t.bigint :company_id

      t.timestamps
    end
  end
end
