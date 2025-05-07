FactoryBot.define do
  factory :email_model do
    subject { Faker::Lorem.sentence }
    body { Faker::Lorem.paragraph }
    company
  end
end
