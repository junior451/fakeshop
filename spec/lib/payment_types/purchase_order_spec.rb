require 'rails_helper'
RSpec.describe PaymentTypes::PurchaseOrder do
  describe '#make_payment' do
    let(:check_type) { PaymentTypes::PurchaseOrder.new }
    let(:payment_info) { {po_no: "1234433342434"} }
    let(:order_id) { "010" }
    let(:logged_message) { "Processing Purchase order with po_no: 1234433342434 for order_no #{order_id}" }

    it "makes the payment and logs" do
      expect(Rails.logger).to receive(:info).with(logged_message)

      check_type.make_payment(order_id, payment_info)
    end
  end
end