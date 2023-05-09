require 'rails_helper'

RSpec.describe "Orders", type: :request do
  describe "/new" do
    it "doesnt allow the creation of new orders if cart is empty" do
      get new_order_url
  
      expect(response).to redirect_to(store_index_url)
  
      follow_redirect!
  
      expect(response.body).to include("Your cart is empty")
    end

    it "returns a sucessful response when cart isnt empty" do
      product = create(:product)

      post "/line_items", :params => { product_id: product.id }

      get new_order_url

      expect(assigns(:order) == Order.new)
      expect(response.status).to eq 200
      expect(response).to render_template(:new)
    end
  end

  describe "/create" do
    it "adds the line items to an order" do
      product = create(:product)

      2.times do
        post "/line_items", :params => {:product_id => product.id}
      end

      post "/orders", params: { order: { name: "my order", address: "34 Spedhall Rd", email: "MyText@gmail.co", paytype: "Check" } }

      expect(LineItem.first.cart).to eq(nil)
      expect(LineItem.first.order_id) == Order.first.id
      expect(Order.first.line_items.first).to eq(LineItem.first)
      expect(response).to redirect_to(store_index_url)
    end
  end

  describe "update" do
    let(:line_item) { create(:line_item, quantity: 3) }

    before do
      session = {cart_id: line_item.cart.id}
      allow_any_instance_of(OrdersController).to receive(:session).and_return(session)
      
      post "/orders", params: { order: { name: "my order", address: "34 Spedhall Rd", email: "MyText@gmail.co", paytype: "Check" } }
    end

    it "updates the shipping date of an order" do
      date_shipped = DateTime.now

      put "/orders/#{Order.first.id}", params: { order: { ship_date:  date_shipped} }

      shipping_date = Order.first.ship_date

      expect(shipping_date.localtime.to_s).to eq(date_shipped.localtime.to_s)
    end

    it "sends an email notification to the user" do
      put "/orders/#{Order.first.id}", params: { order: { ship_date:  DateTime.now} }

      order = Order.first
      mail =  OrderMailer.shipped(order)

      expect(mail.subject).to eq("Pragmatic Store Order Shipped")
      expect(mail.to).to eq([order.email])
      expect(mail.from).to eq(["depot@example.com"])
      expect(mail.body.encoded.to_s).to include("This is just to let you know that we've shipped your recent order")
      expect(mail.body.encoded.to_s).to include("Shipped on #{order.ship_date.localtime.strftime("%m/%d/%y")}")
      expect(mail.body.encoded.to_s).to include("3 x Ruby on Rails Book")
    end
  end
end
