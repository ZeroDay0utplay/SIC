FactoryBot.define do
  factory :company do
    social_reason { "IDEO Groupe" }
    email { "contact@ideo-groupe.com" }
    tel { "123456789" }
    establishment { "My Establishment" }
    taux_tva { "20%" }
    iban { "DE1234567890" }
    bic { "GENODEF1" }
    prefix_bill { "FAC" }
    prefix_quote { "DEV" }
    prefix_credit { "AVR" }
    footer_page { "Footer content" }
    subdomain { "ideo" }

    logo { Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/dummy_logo.png"), "image/png") }

    after(:create) do |company|
      company.logo.attach(io: File.open(Rails.root.join("spec/fixtures/dummy_logo.png")), filename: "dummy_logo.png", content_type: "image/png")
    end
  end
end
