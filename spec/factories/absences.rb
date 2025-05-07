FactoryBot.define do
  factory :absence do
    user
    date_start { Date.current }
    date_end { Date.current + 15.days }
    motif { "Lorem Ipsum" }
    type_absence { :personal_reason }
    state { 1 }
  end
end
