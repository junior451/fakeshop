require 'rails_helper'

RSpec.describe "LineItems", type: :request do
  describe "/create" do
    context "adding a line item" do
      it "creates a line item and adds it to the cart" do
        product = create(:product)
  
        post "/line_items", :params => {:product_id => product.id}
  
        follow_redirect!
  
        expect(LineItem.first.product_id).to eq(product.id)
        expect(response.body).to include(product.title)
        expect(response.body).to include(LineItem.first.cart.total_price.to_s)
      end  
    end

    context "adding multiple items which are duplicates" do
      it "creates the same products with the number of duplicates as the quantity" do
        product = create(:product)

        2.times do
          post "/line_items", :params => {:product_id => product.id}
        end

        follow_redirect!

        expect(LineItem.first.quantity).to eq 2
        expect(response.body).to include("2")
        expect(response.body).to include(product.title)
        expect(response.body).to include((product.price * 2).to_s)
      end
    end

    context "adding multiple unique line items" do
      it "adds individual line items to the cart" do
        product1 = create(:product)
        product2 = create(:product_line_item)

        post "/line_items", :params => {:product_id => product1.id}
        post "/line_items", :params => {:product_id => product2.id}

        follow_redirect!

        expect(response.body).to include("1")
        expect(response.body).to include(product1.title)
        expect(response.body).to include(product2.title)
        expect(response.body).to include((product1.price + product2.price).to_s)
      end
    end
  end

  describe "decrement" do
    context "when the quantity of the line item is 1" do
      let(:item) { create(:line_item) }
      
      it "doesnt delete the item" do
        delete "/line_items/decrement/#{item.id}"

        expect(LineItem.first.quantity).to eq 1
      end

      it "outputs the correct message on the page" do

        delete "/line_items/decrement/#{item.id}"

        follow_redirect!

        expect(response.body).to include("Cannot decrement any further")
      end
    end

    context "when the quantity is more than 1" do
      let(:item) { create(:line_item) }

      it "decrements the quantity of the item" do
        item.quantity = 2
        item.save

        delete "/line_items/decrement/#{item.id}"

        expect(LineItem.first.quantity).to eq 1
      end
    end
  end
end
