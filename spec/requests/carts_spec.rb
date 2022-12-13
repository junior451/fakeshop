require 'rails_helper'

RSpec.describe "Carts", type: :request do
  describe "GET /carts/:id" do
    let(:line_item) { create(:line_item) }

    it "returns the correct response" do

      get "/carts/#{line_item.cart.id}"

      expect(response.body).to include(line_item.product.title)
    end
  end

  describe "Destroy cart" do
    let(:line_item) { create(:line_item) }
    it "empties the cart" do
      session = {cart_id: line_item.cart.id}
      allow_any_instance_of(CartsController).to receive(:session).and_return(session)

      delete "/carts/#{line_item.cart.id}"
      
      follow_redirect!
      expect(response.body).to include("Your cart is empty")
      expect(Cart.count).to eq(0)
    end

  end

end
