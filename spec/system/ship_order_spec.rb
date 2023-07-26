require 'rails_helper'

RSpec.describe 'Ship Order', type: :system do
  it "allows pending orders to be shipped" do
    order = create(:order, ship_date: nil)
    line_item = create(:line_item, order_id: order.id, quantity: 3)

    login

    visit orders_path

    expect(page.body).to include(order.name)
    expect(page.body).to include(order.created_at.localtime.strftime("%d/%m/%y"))

    click_button 'Ship Order!'

    expect(page.body).to include("Date Shipped: #{Order.first.ship_date.localtime.strftime("%d/%m/%y")}" )
  end
end