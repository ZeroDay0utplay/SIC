class CreateSubcontractorUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :subcontractor_users do |t|
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.string :email
      t.string :post
      t.string :type
      t.boolean :is_archived
      t.bigint :address_id
      t.references :subcontractor, null: false, foreign_key: true

      t.timestamps
    end
  end
end
