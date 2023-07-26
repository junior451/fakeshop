require 'rails_helper'

RSpec.describe 'Who Bought Product', type: :system do
  it "lists the details of the orders for that specific product" do
    product = create(:product)
    
    order_1 = create(:order, name: "Anthony Levy")
    line_item = create(:line_item, product_id: product.id, cart_id: nil, quantity: 3, order_id: order_1.id)
    
    order_2 = create(:order, name: "Captain Levy", address: "50 Speed Avanue", paytype: "Credit card")
    line_item_2 = create(:line_item, product_id: product.id, cart_id: nil, quantity: 4, order_id: order_2.id)
    
    login
    
    visit products_path
    click_link "Who Bought"

    total_revenue = (line_item.total_price + line_item_2.total_price).to_s

    page_content_items = [ order_1.name, order_1.address, order_1.paytype, line_item.quantity.to_s, order_2.name, 
      order_2.address, order_2.paytype, line_item_2.quantity.to_s, total_revenue ]

    page_content_items.each do |item|
      expect(page.body).to include(item)
    end
  end
end