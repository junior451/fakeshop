require "rails_helper"

RSpec.describe ErrorsMailer, type: :mailer do
  describe "#invalid_cart" do
    let(:mail) { ErrorsMailer.invalid_cart("Attempt to access an invalid cart gave an error") }

    it "renders the headers" do
      expect(mail.subject).to eq("System Error Invalid cart")
      expect(mail.to).to eq(["user1@example.com"])
      expect(mail.from).to eq(["depot@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Invalid Cart Errors\r\n\r\nAttempt to access an invalid cart gave an error\r\n\r\n")
    end
  end

  describe "#payment_failure" do
    let(:order) { create(:order) }
    let(:mail) { ErrorsMailer.payment_failure(order) }

    it "renders the headers" do
      expect(mail.to.first).to eq(order.email)
      expect(mail.from.first).to eq("depot@example.com")
      expect(mail.subject).to eq("Failed to process payment info")
    end

    it "renders the body" do
      expect(mail.body.encoded).to include("The payment failed to process for order_no #{order.id}. Double check and enter your details again")
    end
  end
end
