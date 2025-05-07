class CreatePaymentMethods < ActiveRecord::Migration[8.0]
  def change
    create_table :payment_methods do |t|
      t.bigint :commercial_id
      t.date :deadline_regle
      t.date :delai_regle
      t.integer :discount_type # enum []
      t.integer :payment_mode # enum []
      t.string :bank_transfer_reference
      t.float :paid_amount
      t.date :paid_amount_date
      t.integer :payment_status  # enum []
      t.timestamps
    end
  end
end
