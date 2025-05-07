FactoryBot.define do
  factory :column_item do
    title { "MyString" }
    is_archived { false }
    is_private { false }
    order { 1 }
    board { nil }
  end
end
