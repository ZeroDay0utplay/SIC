FactoryBot.define do
  factory :commercial_detail do
    display_unit_count { true }
    display_description { true }
    display_empty_fields { false }
    display_footer { true }
    display_global_discount { true }
    display_discount { true }
    display_heading { true }
    display_legal_mentions { true }
    display_amount_before_tax { true }
    display_days_column { true }
    display_days { true }
    display_service_details { true }
    display_quantity { true }
    display_reference { true }
    display_title { true }
    display_total_with_tax { true }
  end
end
