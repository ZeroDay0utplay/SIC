class CreateDocuments < ActiveRecord::Migration[8.0]
  def change
    create_table :documents do |t|
      t.integer :document_type, null: false
      t.date :expiration_date
      t.integer :document_status
      t.text :notice
      t.references :documentable, polymorphic: true, null: false, index: true
      t.bigint :company_id

      t.timestamps
    end
  end
end
