require 'rails_helper'

RSpec.describe "LineItems", type: :request do
  describe " /create" do
    it "creates a line item and adds it to the cart" do
      product = create(:product)

      post "/line_items", :params => {:product_id => product.id}

      follow_redirect!

      expect(LineItem.first.product_id).to eq(product.id)
      expect(response.body).to include("Line item was successfully created")
      expect(response.body).to include(product.title)

    end  
  end

end
