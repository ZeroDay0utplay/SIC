FactoryBot.define do
  factory :client do
    name { Faker::Company.name }
    email { Faker::Internet.email }
    company

    trait :particular do
      client_type { 0 }
    end

    trait :professional do
      client_type { 1 }
    end

    trait :with_contacts do
      transient do
        contacts_count { 2 }
      end

      after(:create) do |client, evaluator|
        create_list(:client_contact, evaluator.contacts_count, client: client)
      end
    end
  end
end
