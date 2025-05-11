class CreateCommercials < ActiveRecord::Migration[8.0]
  def change
    create_table :commercials do |t|
      t.bigint :user_id, null: true
      t.bigint :company_id, null: true
      t.jsonb :extracted_data, default: {}
      t.timestamps
    end
  end
end
