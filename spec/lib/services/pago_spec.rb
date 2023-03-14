require 'rails_helper'

RSpec.describe Services::Pago do
  pago = Services::Pago.new
  order_id = "010"
  payment_type = PaymentTypes::Check.new
  payment_info = { routing_no: "213442", account_no: "123453553" }

  describe "#make_payment" do
    it "Processes the payment and logs the results" do
      #expect(Rails.logger).to receive(:info).with("Done Processing Payment for order_no 010")
  
      payment_result = pago.make_payment(order_id, payment_type, payment_info)
  
      expect(payment_result.succeeded).to be(true)
    end
  end

end
