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
require 'rails_helper'

RSpec.describe LineItem, type: :model do
  let(:line_item) { build(:line_item) }
  let(:cart) { create(:cart) }
  let(:product) { create(:product) }

  it "is valid with valid attrubutes" do
    expect(line_item).to be_valid
  end

  it "is invalid without a product" do
    line_item = build(:line_item, product_id: nil, cart_id: cart.id )
    expect(line_item).to_not be_valid
    expect(line_item.errors.full_messages.first).to include("Product must exist")
  end

  it { should belong_to :product }
end
