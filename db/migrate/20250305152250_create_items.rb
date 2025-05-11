class CreateItems < ActiveRecord::Migration[8.0]
  def change
    create_table :items do |t|
      t.bigint :commercial_id
      t.bigint :prestation_id
      t.float :unit_price
      t.float :quantity
      t.string :unit
      t.integer :days
      t.integer :order
      t.text :description
      t.boolean :has_description
      t.boolean :has_reduction      
      t.integer :reduction_unit
      t.float :reduction

      t.timestamps
    end
  end
end
