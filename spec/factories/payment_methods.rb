FactoryBot.define do
  factory :payment_method do
    deadline_regle { Faker::Date.forward(days: 60) }
    delai_regle { Date.today + rand(30..90).days }
    discount_type { ["percentage", "amount"].sample }
    payment_mode { ["cash", "cheque", "transfer_bank"].sample }
    bank_transfer_reference { Faker::Bank.iban }
    paid_amount { Faker::Number.decimal(l_digits: 3, r_digits: 2) }
    paid_amount_date { Faker::Date.backward(days: 30) }
    payment_status { ["pending", "partial", "paid"].sample }
  end
end
