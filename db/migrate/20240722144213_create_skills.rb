class CreateSkills < ActiveRecord::Migration[7.1]
  def change
    create_table :skills do |t|
      t.string :name
      t.bigint :company_id

      t.timestamps
    end

    add_index :skills, :company_id
  end
end
