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

  describe "#charge!" do
    before do
      order.save
    end

    context "when payment details are entered" do
      it "proccesses the payment and send a notification email to the user" do
        paytype_params = { credit_card_number: "11233", expiration_date: "24534" }
  
    
        order.charge!(paytype_params)
  
        mail = ActionMailer::Base.deliveries.last
  
        expect(mail.from.first).to eq("depot@example.com")
        expect(mail.to.first).to eq(order.email)
        expect(mail.subject).to eq("Pragmatic Store Order Confirmation")
  
        expect(mail.body.encoded).to include ("Dear Jay Coleman\r\n\r\nThank you for your recent order from The Pragmatic Store.")
        expect(mail.body.encoded).to include ("You ordered the following items:\r\n\r\n\r\n\r\nWe'll send you a separate email when your order ships.\r\n\r\n")
  
        expect(ActionMailer::Base.deliveries.count).to be 1
      end
    end

    context "when payment details are missing" do
      it "the payment processinf fails and send an email to the user about the failure" do
        paytype_params = { credit_card_number: "", expiration_date: "" }
    
        order.charge!(paytype_params)
  
        mail = ActionMailer::Base.deliveries.last
  
        expect(mail.from.first).to eq("depot@example.com")
        expect(mail.to.first).to eq(order.email)
        expect(mail.subject).to eq("Failed to process payment info")
  
        expect(mail.body.encoded).to include ("The payment failed to process for order_no #{order.id}. Double check and enter your details again")
  
        expect(ActionMailer::Base.deliveries.count).to be 1
      end
    end
  end
end
