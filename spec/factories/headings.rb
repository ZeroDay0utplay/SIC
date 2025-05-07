FactoryBot.define do
  factory :heading do
    title { Faker::Lorem.sentence(word_count: 3) }
    description { Faker::Lorem.paragraph(sentence_count: 2) }
    client
  end
end
