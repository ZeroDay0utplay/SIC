class CreateTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.integer :order
      t.date :delivery_date
      t.integer :priority
      t.bigint :column_item_id
      t.bigint :user_id

      t.timestamps
    end
  end
end
