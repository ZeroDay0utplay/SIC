class CreateExpenses < ActiveRecord::Migration[8.0]
  def change
    create_table :expenses do |t|
      t.references :user, null: false, foreign_key: true
      t.references :company, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.float :amount
      t.integer :status

      t.timestamps
    end
  end
end
