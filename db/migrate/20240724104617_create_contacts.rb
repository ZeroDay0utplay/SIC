class CreateContacts < ActiveRecord::Migration[7.1]
  def change
    create_table :contacts do |t|
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.string :email
      t.string :job
      t.string :tags
      t.integer :role
      t.string :company_name
      t.bigint :company_id

      t.timestamps
    end
  end
end
