require "rails_helper"

RSpec.describe OrderMailer, type: :mailer do
  describe "received" do
    let(:product) { create(:product)}
    let(:order) { create(:order) }
    let(:line_item) { create(:line_item, product_id: product.id, quantity: 3) }
    let(:mail) { OrderMailer.received(order) }

    it "renders the headers" do
      expect(mail.subject).to eq("Pragmatic Store Order Confirmation")
      expect(mail.to).to eq([order.email])
      expect(mail.from).to eq(["depot@example.com"])
    end
    
    it "renders the body" do
      order.line_items << line_item
      expect(mail.body.encoded.to_s).to include("Dear Jay Coleman\r\n\r\nThank you for your recent order from The Pragmatic Store.")
      expect(mail.body.encoded.to_s).to include("You ordered the following items:\r\n\r\n 3 x Programming Crystal\r\n\r\n")
      expect(mail.body.encoded.to_s).to include("We'll send you a separate email when your order ships.\r\n\r\n")
    end
  end

  describe "shipped" do
    let(:product) { create(:product)}
    let(:order) { create(:order) }
    let(:line_item) { create(:line_item, product_id: product.id, quantity: 3) }
    let(:mail) { OrderMailer.shipped(order) }

    before do
      order.line_items << line_item
    end

    it "renders the headers" do
      expect(mail.subject).to eq("Pragmatic Store Order Shipped")
      expect(mail.to).to eq([order.email])
      expect(mail.from).to eq(["depot@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to include("Pragmatic Order Shipped")
      expect(mail.body.encoded).to include("This is just to let you know that we've shipped your recent order")
      expect(mail.body.encoded).to include("#{line_item.quantity.to_s} x #{product.title}")
      expect(mail.body.encoded).to include("Total Cost: #{sprintf("£%d", line_item.total_price)}")
    end
  end

end
