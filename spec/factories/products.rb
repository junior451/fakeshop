FactoryBot.define do
  factory :product do
    title { 'Programming Crystal' }
    description  { 'Crystal is for Ruby programmers who want more performance' }
    image_url { 'lorem.jpg' }
    price { 11.99 }
  end
end