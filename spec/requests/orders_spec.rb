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
end
