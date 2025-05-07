FactoryBot.define do
  factory :subcontractor_user do
    first_name { "John" }
    last_name { "Doe" }
    phone { "1234567890" }
    email { "john.doe@example.com" }
    association :subcontractor
  end
end
