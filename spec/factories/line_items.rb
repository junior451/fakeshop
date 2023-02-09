# == Schema Information
#
# Table name: line_items
#
#  id         :bigint           not null, primary key
#  product_id :bigint           not null
#  cart_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  quantity   :integer          default(1)
#  order_id   :bigint
#
FactoryBot.define do
  factory :line_item do
    product { association :product_line_item }
    cart { association :cart }
  end
end
