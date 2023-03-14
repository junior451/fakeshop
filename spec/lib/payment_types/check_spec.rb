require 'rails_helper'

RSpec.describe PaymentTypes::Check do
  describe '#make_payment' do
    let(:check_type) { PaymentTypes::Check.new }
    let(:payment_info) { {routing_no: "123443", account_no: "34233442"} }
    let(:order_id) { "010" }
    let(:logged_message) { "Processing check with routing_no: 123443 and account_no: 34233442 for order_no #{order_id}" }

    it "makes the payment and logs" do
      expect(Rails.logger).to receive(:info).with(logged_message)

      check_type.make_payment(order_id, payment_info)
    end
  end
end