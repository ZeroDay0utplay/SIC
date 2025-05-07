FactoryBot.define do
  factory :material do
    type { "" }
    notes { "MyText" }
    serial_number { "MyString" }
    driver_id { "" }
    is_active { false }
  end
end
