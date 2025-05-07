FactoryBot.define do
  factory :task do
    title { "MyString" }
    is_archived { false }
    is_private { false }
    order { 1 }
    column_item { nil }
    description { "MyText" }
    user { nil }
    delivery_date { "2024-09-18" }
    Priority { 1 }
  end
end
