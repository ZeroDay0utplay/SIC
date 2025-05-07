FactoryBot.define do
  factory :board do
    title { "MyString" }
    is_archived { false }
    is_private { false }
    order { 1 }
  end
end
