class CreateCommercials < ActiveRecord::Migration[8.0]
  def change
    create_table :commercials do |t|
      t.references :user, null: true, foreign_key: true
      t.references :client, null: true, foreign_key: true
      t.references :company, null: true, foreign_key: true
      t.float :fraud_score
      t.string :reference
      t.integer :state, default: 0 # enum []
      t.text :description
      t.string :document_title
      t.string :photo, null: true
      t.string :type

      t.timestamps
    end
  end
end
