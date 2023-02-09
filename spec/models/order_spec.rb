# == Schema Information
#
# Table name: orders
#
#  id         :bigint           not null, primary key
#  name       :string
#  address    :text
#  email      :string
#  paytype    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:order) { build(:order) }

  it "is valid with valid attributes" do
    expect(order).to be_valid
  end

  it "isn't valid without a name" do
    order.name = nil
    expect(order).to_not be_valid
  end

  it "isn't valid without an email" do
    order.email = nil
    expect(order).to_not be_valid
  end

  it "isn't valid without an address" do
    order.address = nil
    expect(order).to_not be_valid
  end

  it "isn't valid without a pay_type" do
    order.paytype = nil
    expect(order).to_not be_valid
  end

  it "expects paytype to be in the range from 0-2" do
    paytypes = ["Check", "Credit card", "Purchase order"]

    paytypes.each do |type|
      order.paytype = type
      expect(order).to be_valid
    end
    
  end  

  it "expects to raise error is paytype is not included" do
    expect { build(:order, paytype: "Bank Transfer") }.to raise_error(ArgumentError)
  end  
end
