class CreateClients < ActiveRecord::Migration[7.1]
  def change
    create_table :clients do |t|
      t.string :name, null: false
      t.integer :client_type, default: 0, null: false
      t.string :logo
      t.integer :role
      t.string :reference
      t.bigint :heading_id
      t.bigint :company_id
      t.string :email

      t.timestamps
    end
  end
end
