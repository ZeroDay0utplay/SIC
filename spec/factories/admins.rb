FactoryBot.define do
  factory :admin, class: "Admin" do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    password { "password" }
    password_confirmation { "password" }
    authentication_token { SecureRandom.hex(20) }
    role { "admin" }
    type { "Admin" }
    company
  end
end
