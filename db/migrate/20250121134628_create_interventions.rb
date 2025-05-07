class CreateInterventions < ActiveRecord::Migration[8.0]
  def change
    create_table :interventions do |t|
      t.bigint :client_id
      t.bigint :user_id
      t.bigint :heading_id
      t.bigint :company_id
      t.boolean :is_closed, default: false
      t.boolean :display_heading, default: false

      t.timestamps
    end

    add_index :interventions, :client_id
    add_index :interventions, :company_id
  end
end
