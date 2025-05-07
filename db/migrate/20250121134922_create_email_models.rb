class CreateEmailModels < ActiveRecord::Migration[8.0]
  def change
    create_table :email_models do |t|
      t.text :subject
      t.text :body
      t.bigint :company_id

      t.timestamps
    end
    add_index :email_models, :company_id
  end
end
