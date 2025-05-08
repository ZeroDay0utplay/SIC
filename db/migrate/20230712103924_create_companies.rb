class CreateCompanies < ActiveRecord::Migration[7.1]
  def change
    create_table :companies do |t|
      t.string :social_reason
      t.string :siren
      t.string :num_tva
      t.string :email
      t.string :tel
      t.text :footer_page
      t.text :activity
      t.date :creation_date
      t.string :logo
      t.string :establishment
      t.string :iban
      t.string :bic
      t.integer :taux_tva
      t.string :prefix_bill, default: "FACT-(AA)-(mois)-"
      t.string :prefix_quote, default: "DEV-(AA)-(mois)-"
      t.string :prefix_credit, default: "AVR-(AA)-(mois)-"
      t.string :subdomain
      t.boolean :is_archived, default: false

      t.timestamps
    end
  end
end
