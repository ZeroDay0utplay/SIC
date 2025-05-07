FactoryBot.define do
  factory :planning do
    association :company
    association :client
    association :prestation
    association :intervention
    association :admin

    type { nil } # Default to nil, override in specific factories
    status { "draft" }
    start_on { Date.today }
    finish_on { Date.today + 1.week }

    # Traits for common scenarios
    trait :with_intervention do
      association :intervention
    end

    trait :with_user do
      association :user
    end

    # Specific type factories
    factory :punctual_planning do
      type { "Punctual" }
      # Add Punctual-specific attributes if needed
    end

    factory :regular_planning do
      type { "Regular" }
      # Add Regular-specific attributes if needed
    end

    factory :flat_rate_planning do
      type { "FlatRate" }
      # Add FlatRate-specific attributes if needed
    end
  end
end
