FactoryBot.define do
  factory :product do
    title { 'Programming Crystal' }
    description  { Faker::Lorem.paragraph(sentence_count: 1) }
    image_url { 'lorem.jpg' }
    price { 11.99 }
  end
end