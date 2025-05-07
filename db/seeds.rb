Superadmin.first_or_create(email: "superadmin@example.com", active: true, role: 5, password: "password")

ideo_company = Company.create(social_reason: "Ideo Groupe", subdomain: "ideogroupe")
test_company = Company.create(social_reason: "Test Company", subdomain: "testcompany")

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

  30.times do
    Contact.create(
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      phone: Faker::PhoneNumber.phone_number,
      email: Faker::Internet.email,
      job: Faker::Job.title,
      tags: nil, role: [0, 1].sample,
      company_name: Faker::Company.name,
      company_id: Company.ids.sample
    )
  end

  Client.all.each do |client|
    5.times do
      client.contacts << Contact.all.sample
    end
  end

  Company.ids.each do |type|
    Prestation.type_prestations.values.each do |type|
      7.times do
        Prestation.create(
          name: Faker::Name.name,
          description: Faker::Lorem.paragraphs.join,
          remark: Faker::Lorem.paragraphs.join,
          alias: Faker::Name.name,
          price: rand(100..999),
          unity: %w[Jour Pièce Agent Forfait Camion].sample,
          type_prestation: type,
          company_id: Company.ids.sample
        )
      end
    end
  end

  Client.all.each do |client|
    5.times do
      Heading.create(title: Faker::Name.name, description: Faker::Lorem.paragraph, client: client)
    end
  end

  Client.all.each do |client|
    5.times do
      intervention = Intervention.create(admin: client.company.admins.sample, client: client, heading: Heading.find_by(client: client), company: client.company)

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
        addressable: intervention
      )
    end
  end

  Company.all.each do |company|
    5.times do
      sub = Subcontractor.create(
        company_name: Faker::Company.name,
        manager: Faker::Name.name,
        email: Faker::Internet.email,
        active: true,
        color: Faker::Color.hex_color,
        company: company
      )

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
        addressable: sub
      )

      5.times do
        agent = SubcontractorAgent.create(
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          email: Faker::Internet.email,
          phone: Faker::PhoneNumber.cell_phone.gsub(/\D/, "")[0..9],
          subcontractor: sub
        )

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
          addressable: agent
        )

        admin = SubcontractorAdmin.create(
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          email: Faker::Internet.email,
          phone: Faker::PhoneNumber.cell_phone.gsub(/\D/, "")[0..9],
          subcontractor: sub
        )

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
          addressable: admin
        )
      end
    end
  end

  100.times do
    quote = Quote.create!(
      intervention_id: Intervention.ids.sample,
      user_id: Admin.ids.sample,
      created_by: Admin.ids.sample,
      client_id: Client.ids.sample,
      heading_id: Heading.ids.sample,
      prestation_id: Prestation.ids.sample,
      company_id: Company.ids.sample,
      reference: Faker::Alphanumeric.alpha(number: 10).upcase,
      validate_date: Faker::Date.between(from: 30.days.ago, to: Date.today),
      pretations_details: Faker::Lorem.paragraph,
      state: rand(0..2),
      signed_at: Faker::Date.between(from: 30.days.ago, to: Date.today),
      must_signed: [true, false].sample,
      description: Faker::Lorem.sentence,
      document_title: Faker::Company.name,
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

    5.times do
      CommercialContact.create!(
        commercial_id: quote.id,
        contact_id: rand(1..Contact.ids.count)
      )
    end
  end
end


3.times do |i|
  Board.create(
    title: Faker::Name.name,
    order: i,
    company_id: ideo_company.id
  )
end

Board.all.each do |board|
  5.times do |i|
    ColumnItem.create(
      title: Faker::Name.name,
      order: i,
      board_id: board.id
    )
  end

  ColumnItem.all.each do |column_item|
    rand(1..5).times do
      Task.create(
        title: Faker::Name.name,
        description: Faker::Lorem.paragraph,
        order: rand(1..10),
        delivery_date: Faker::Date.between(from: 30.days.ago, to: Date.today),
        priority: rand(0..2),
        column_item_id: column_item.id,
        user_id: Admin.ids.sample,
        photos: [
          Rails.root.join("app/assets/images/default_avatar.png"),
          Rails.root.join("app/assets/images/default_avatar.png")
        ]
      )
    end
  end
end