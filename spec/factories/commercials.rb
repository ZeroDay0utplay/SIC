# spec/factories/commercials.rb
FactoryBot.define do
  factory :commercial do
    sequence(:reference) { |n| "QUO-#{n.to_s.rjust(6, "0")}" }
    validate_date { Faker::Date.forward(days: 30) }
    state { "draft" }

    association :company
    association :client
    association :admin
    association :creator, factory: :user
    association :heading
    association :intervention

    trait :with_payment_method do
      after(:build) do |commercial|
        commercial.build_payment_method(attributes_for(:payment_method))
      end
    end

    trait :with_commercial_detail do
      after(:build) do |commercial|
        commercial.build_commercial_detail(attributes_for(:commercial_detail))
      end
    end

    trait :with_items do
      after(:create) do |commercial|
        create_list(:item, 2, commercial: commercial)
      end
    end

    # Quote-specific configuration
    factory :quote, class: "Quote" do
      type { "Quote" }
      signed_before { Faker::Date.forward(days: 45) }
      must_signed { [true, false].sample }
      document_title { "Devis #{reference}" }

      factory :complete_quote do
        with_payment_method
        with_commercial_detail
        with_items
      end
    end
  end
end
