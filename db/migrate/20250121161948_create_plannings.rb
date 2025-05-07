class CreatePlannings < ActiveRecord::Migration[8.0]
  def change
    create_table :plannings do |t|
      t.references :client, null: false, foreign_key: true
      t.references :intervention, null: false, foreign_key: true
      t.references :prestation, null: false, foreign_key: true
      t.bigint :user_id
      t.bigint :quote_id
      t.bigint :bill_id
      t.integer :agent_needed
      t.boolean :manual_dispatch
      t.boolean :include_vehicle
      t.boolean :invoiced_agent
      t.boolean :invoiced_truck
      t.text :needs
      t.text :note
      t.text :remark
      t.bigint :mattermost_id
      t.string :mattermost_channel_name
      t.string :type
      t.date :start_on
      t.date :finish_on
      t.jsonb :intervention_days, default: {}
      t.bigint :parent_id
      t.integer :status
      t.bigint :company_id

      t.timestamps
    end

    add_index :plannings, :company_id
  end
end
