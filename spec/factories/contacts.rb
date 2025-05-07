FactoryBot.define do
  factory :contact do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    phone { Faker::PhoneNumber.phone_number }
    email { Faker::Internet.email }
    company_name { Faker::Company.name }
    job { Faker::Job.title }
    role { Contact.roles.keys.sample }
    company

    # Add ability to create with client associations
    trait :with_client do
      after(:create) do |contact|
        create(:client_contact, contact: contact)
      end
    end
  end
end
