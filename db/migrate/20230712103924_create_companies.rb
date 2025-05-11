class CreateCompanies < ActiveRecord::Migration[7.1]
  def change
    create_table :companies do |t|
      t.string :legal_name
      t.string :tax_id
      t.string :email
      t.string :tel
      t.string :logo
      t.string :establishment
      t.string :iban
      t.string :bic
      t.integer :tva_rate

      t.timestamps
    end
  end
end
