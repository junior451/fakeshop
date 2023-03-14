require 'rails_helper'

RSpec.describe PaymentTypes::CreditCard do
  describe '#make_payment' do
    let(:check_type) { PaymentTypes::CreditCard.new }
    let(:payment_info) { {cc_no: "1234433342434", expiration_date: "03/23"} }
    let(:order_id) { "010" }
    let(:logged_message) { "Processing credit card with cc_no: 1234433342434 and expiration_date: 03/23 for order_no #{order_id}" }

    it "makes the payment and logs" do
      expect(Rails.logger).to receive(:info).with(logged_message)

      check_type.make_payment(order_id, payment_info)
    end
  end
end