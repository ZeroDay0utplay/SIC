Superadmin.first_or_create(email: "superadmin@example.com", active: true, role: 5, password: "password")

ideo_company = Company.create(legal_name: "Ideo Groupe", tax_id: "FR123456789")
test_company = Company.create(legal_name: "Test Company", tax_id: "FR987654321")

Admin.create(email: "ideo@example.com", active: true, password: "password", company: ideo_company, first_name: "Ideo", last_name: "Admin")
Admin.create(email: "test@example.com", active: true, password: "password", company: test_company, first_name: "Test", last_name: "Admin")

ActiveRecord::Base.transaction do
  20.times do
    Admin.create!(
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      email: Faker::Internet.unique.email,
      phone: Faker::PhoneNumber.cell_phone.gsub(/\D/, "")[0..9],
      active: [true, false].sample,
      company_id: Company.ids.sample,
      role: rand(0..2),
      platform: rand(0..1),
      password: "password"
    )
    Agent.create!(
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      email: Faker::Internet.unique.email,
      phone: Faker::PhoneNumber.cell_phone.gsub(/\D/, "")[0..9],
      active: [true, false].sample,
      company_id: Company.ids.sample,
      role: rand(0..2),
      platform: rand(0..1),
      password: "password"
    )
  end

  20.times do
    Client.create(
      name: Faker::Name.name,
      email: Faker::Internet.email,
      role: Client.roles.values.sample,
      client_type: Client.client_types.values.sample,
      reference: Faker::Barcode.isbn.first(5),
      company_id: Company.ids.sample
    )
  end


  50.times do
    quote = Quote.create!(
      intervention_id: Intervention.ids.sample,
      user_id: Admin.ids.sample,
      created_by: Admin.ids.sample,
      client_id: Client.ids.sample,
      company_id: Company.ids.sample,
      reference: Faker::Alphanumeric.alpha(number: 10).upcase,
      validate_date: Faker::Date.between(from: 30.days.ago, to: Date.today),
      pretations_details: Faker::Lorem.paragraph,
      state: rand(0..2),
      signed_at: Faker::Date.between(from: 30.days.ago, to: Date.today),
      must_signed: [true, false].sample,
      description: Faker::Lorem.sentence,
      document_title: Faker::Company.legal_name,
      prefix_type: rand(0..3),
      send_at: Faker::Date.between(from: 30.days.ago, to: Date.today),
      type: "Quote"
    )

    CommercialDetail.create!(
      commercial_id: quote.id,
      display_unit_count: [true, false].sample,
      display_description: [true, false].sample,
      display_empty_fields: [true, false].sample,
      display_footer: [true, false].sample,
      display_global_discount: [true, false].sample,
      display_discount: [true, false].sample,
      display_heading: [true, false].sample,
      display_legal_mentions: [true, false].sample,
      display_amount_before_tax: [true, false].sample,
      display_days_column: [true, false].sample,
      display_days: [true, false].sample,
      display_service_details: [true, false].sample,
      display_quantity: [true, false].sample,
      display_reference: [true, false].sample,
      display_title: [true, false].sample,
      display_total_with_tax: [true, false].sample
    )

    PaymentMethod.create!(
      commercial_id: quote.id,
      deadline_regle: Faker::Date.forward(days: 30),
      delai_regle: Faker::Date.forward(days: 60),
      discount_type: rand(0..2),
      payment_mode: PaymentMethod.payment_modes.keys.sample,
      bank_transfer_reference: Faker::Bank.swift_bic,
      paid_amount: Faker::Commerce.price(range: 50..500),
      paid_amount_date: Faker::Date.backward(days: 30),
      payment_status: rand(0..2)
    )

    rand(1..5).times do
      Item.create!(
        commercial_id: quote.id,
        prestation_id: Prestation.ids.sample,
        description: Faker::Commerce.product_name,
        unit_price: Faker::Commerce.price(range: 10..100),
        quantity: rand(1..10),
        unit: %w[kg m² unit piece].sample,
        has_reduction: [true, false].sample,
        days: rand(1..30),
        order: rand(1..10),
        has_description: [true, false].sample,
        reduction_unit: [:currency, :percentage].sample,
        reduction: Faker::Commerce.price(range: 5..50)
      )
    end
    Address.create!(
      street: Faker::Address.street_address,
      complement: Faker::Address.secondary_address,
      postal_code: Faker::Address.zip_code,
      city: Faker::Address.city,
      country: "France",
      latitude: Faker::Address.latitude,
      longitude: Faker::Address.longitude,
      geocoder_value: {},
      zoom: rand(10..15),
      addressable: quote
    )
  end
end