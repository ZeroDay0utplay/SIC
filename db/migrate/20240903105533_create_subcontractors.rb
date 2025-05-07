class CreateSubcontractors < ActiveRecord::Migration[7.1]
  def change
    create_table :subcontractors do |t|
      t.string :company_name
      t.string :manager
      t.string :email
      t.string :phone
      t.boolean :active, default: true
      t.string :color
      t.string :logo
      t.string :siret
      t.string :speciality
      t.float :rate_agent
      t.float :rate_mission
      t.bigint :address_id
      t.bigint :company_id

      t.timestamps
    end
  end
end
