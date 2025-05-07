class CreateCommercialDetails < ActiveRecord::Migration[8.0]
  def change
    create_table :commercial_details do |t|
      t.bigint :commercial_id
      t.boolean :display_unit_count, default: false, null: false
      t.boolean :display_description, default: false, null: false
      t.boolean :display_empty_fields, default: false, null: false
      t.boolean :display_footer, default: false, null: false
      t.boolean :display_global_discount, default: false, null: false
      t.boolean :display_discount, default: false, null: false
      t.boolean :display_heading, default: false, null: false
      t.boolean :display_legal_mentions, default: false, null: false
      t.boolean :display_amount_before_tax, default: false, null: false
      t.boolean :display_days_column, default: false, null: false
      t.boolean :display_days, default: false, null: false
      t.boolean :display_service_details, default: false, null: false
      t.boolean :display_quantity, default: false, null: false
      t.boolean :display_reference, default: false, null: false
      t.boolean :display_title, default: false, null: false
      t.boolean :display_total_with_tax, default: false, null: false

      t.timestamps
    end
  end
end
