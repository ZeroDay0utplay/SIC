FactoryBot.define do
  factory :item do
    unit_price { Faker::Number.decimal(l_digits: 3, r_digits: 2) }
    quantity { rand(1..10) }
    unit { ["hour", "day", "unit", "m²"].sample }
    days { rand(1..30) }
    order { rand(1..10) }
    description { Faker::Lorem.sentence }
    has_description { true }
    has_reduction { [true, false].sample }
    reduction_unit { ["percentage", "currency"].sample }
    reduction { Faker::Number.decimal(l_digits: 2) }

    association :commercial
    association :prestation
  end
end
