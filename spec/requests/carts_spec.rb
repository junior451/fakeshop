require 'rails_helper'

RSpec.describe "Carts", type: :request do
  describe "GET /carts/:id" do
    let(:line_item) { create(:line_item) }

    it "returns the correct response" do
      session = {cart_id: line_item.cart.id}
      allow_any_instance_of(CartsController).to receive(:session).and_return(session)
      
      get "/carts/#{line_item.cart.id}"

      expect(response.body).to include(line_item.product.title)
    end
  end

  describe "Destroy cart" do
    it "empties the cart" do
      line_item =  create(:line_item)

      session = {cart_id: line_item.cart.id}
      allow_any_instance_of(CartsController).to receive(:session).and_return(session)

      delete "/carts/#{session[:cart_id]}"

      expect(Cart.count).to eq(0)
      
      follow_redirect!

      expect(response.body).to include("Your cart is empty")
    end
  end

  describe "Invalid cart" do
    it "enqeues the an email which will be sent to the system administrator about the error" do
      expect { get "/carts/4" }.to have_enqueued_job(ActionMailer::MailDeliveryJob)
    end

    it "logs the error and redirect to the store page" do
      allow(Rails.logger).to receive(:error)

      get "/carts/4"

      expect(response).to redirect_to(store_index_url)
      expect(Rails.logger).to have_received(:error).with("Attempted to access invalid cart 4")
    end

  end

end
