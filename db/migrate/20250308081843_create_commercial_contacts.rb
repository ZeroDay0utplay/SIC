class CreateCommercialContacts < ActiveRecord::Migration[8.0]
  def change
    create_table :commercial_contacts do |t|
      t.references :commercial, null: false, foreign_key: true
      t.references :contact, null: false, foreign_key: true

      t.timestamps
    end
  end
end
