require 'rails_helper'

RSpec.describe "Orders", type: :request do
  context "when not logged in" do
    it "redirects do the login page when trying to access the products page" do
      get orders_path

      expect(response).to redirect_to(login_url)

      follow_redirect!

      expect(response.body).to include("Please Log In")
    end
  end

  context "when logged in" do
    before do
      login
    end
    
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
        valid_params = { order: { ship_date:  DateTime.now} }
  
        expect { put "/orders/#{Order.first.id}", params: valid_params
        }.to have_enqueued_job.exactly(:once).and have_enqueued_job(ActionMailer::MailDeliveryJob)
      end
    end
  end
end
