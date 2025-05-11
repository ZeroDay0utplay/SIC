FactoryBot.define do
  factory :expense do
    user { nil }
    company { nil }
    category { nil }
    amount { 1.5 }
    status { 1 }
  end
end
