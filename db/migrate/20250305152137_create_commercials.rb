class CreateCommercials < ActiveRecord::Migration[8.0]
  def change
    create_table :commercials do |t|
      t.bigint :intervention_id, null: true
      t.bigint :user_id, null: true
      t.bigint :client_id, null: true
      t.bigint :facture_id, null: true
      t.bigint :heading_id, null: true
      t.bigint :prestation_id, null: true
      t.bigint :company_id, null: true
      t.bigint :report_id, null: true
      t.bigint :template_id, null: true
      t.bigint :created_by
      t.string :reference
      t.date :validate_date
      t.text :pretations_details
      t.integer :state, default: 0 # enum []
      t.date :signed_before
      t.date :signed_at
      t.boolean :must_signed
      t.text :description
      t.string :document_title
      t.integer :prefix_type # enum []
      t.integer :reduction_unit # enum []
      t.float :reduction, default: 0.0
      t.date :send_at
      t.string :photo, null: true
      t.string :type
      t.string :template_name, default: ""
      t.boolean :is_template, default: false

      t.timestamps
    end
  end
end
