FactoryBot.define do
  factory :prestation do
    name { Faker::Name.name }
    description { Faker::Lorem.paragraph }
    remark { Faker::Lorem.paragraph }
    price { Faker::Number.decimal(l_digits: 2) }
    unity { Faker::Name.name }
    type_prestation { :service }
    state { :under_repair }
    company
  end
end
