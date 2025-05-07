FactoryBot.define do
  factory :subcontractor do
    company_name { "Test Company" }
    manager { "Test Manager" }
    email { "test@example.com" }
    phone { "1234567890" }
    active { true }
    color { "#000000" }
    company
  end
end
