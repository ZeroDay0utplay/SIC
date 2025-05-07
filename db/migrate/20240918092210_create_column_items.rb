class CreateColumnItems < ActiveRecord::Migration[7.1]
  def change
    create_table :column_items do |t|
      t.string :title
      t.integer :order
      t.references :board, null: false, foreign_key: true

      t.timestamps
    end
  end
end
