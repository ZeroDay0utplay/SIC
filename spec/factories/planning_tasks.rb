FactoryBot.define do
  factory :planning_task do
    prestation { nil }
    planning { nil }
    start_at { "2025-02-06 15:50:51" }
    end_at { "2025-02-06 15:50:51" }
    description { "MyText" }
  end
end
