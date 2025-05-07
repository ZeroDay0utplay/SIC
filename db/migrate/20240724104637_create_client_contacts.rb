class CreateClientContacts < ActiveRecord::Migration[7.1]
  def change
    create_table :client_contacts do |t|
      t.bigint :client_id, null: false
      t.bigint :contact_id, null: false

      t.timestamps
    end
  end
end
