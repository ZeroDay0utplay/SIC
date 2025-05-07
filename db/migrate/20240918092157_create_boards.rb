class CreateBoards < ActiveRecord::Migration[7.1]
  def change
    create_table :boards do |t|
      t.string :title
      t.integer :order
      t.bigint :company_id

      t.timestamps
    end
  end
end
