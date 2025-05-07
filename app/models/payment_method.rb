class PaymentMethod < ApplicationRecord
  belongs_to :commercial

  enum :payment_mode, [:cheque, :transfer_bank, :cash]
end
