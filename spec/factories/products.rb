# == Schema Information
#
# Table name: products
#
#  id          :bigint           not null, primary key
#  title       :string
#  description :text
#  image_url   :string
#  price       :decimal(8, 2)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
FactoryBot.define do
  factory :product do
    title { 'Programming Crystal' }
    description  { Faker::Lorem.paragraph(sentence_count: 1) }
    image_url { 'lorem.jpg' }
    price { 11.99 }
  end

  factory :product_line_item, class: "Product" do
    title { 'Ruby on Rails Book ' }
    description  { Faker::Lorem.paragraph(sentence_count: 1) }
    image_url { 'lorem.jpg' }
    price { 20.00 }
  end
end
