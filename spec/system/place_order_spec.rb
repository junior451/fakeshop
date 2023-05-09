require 'rails_helper'

RSpec.describe 'Place Order', type: :system, js: true do
  before do
    product = create(:product)

    visit store_index_path

    expect(page).to have_content(product.title)

    click_button 'Add to Cart'
    click_button 'Checkout'

    fill_in 'Name', with: 'Mr Creed'
    fill_in 'Address', with: '30 Speed Rd'
    fill_in 'Email', with: 'creede2@gmail.com'

  end
  
  it "allows the order details to be filled, a Check paytype to be selected and submitted" do
    
    select "Check", from: "order_paytype"

    expect(page).to have_css('#order_routing_number')
    expect(page).to have_css('#order_account_number')

    click_button 'Place Order'

    expect(page).to have_content("Thank you for your order")

    order = Order.first

    expect(order.name).to eq("Mr Creed")
    expect(order.address).to eq("30 Speed Rd")
    expect(order.email).to eq("creede2@gmail.com")
    expect(order.paytype).to eq("Check")
  end

  it "allows the order details to be filled and submitted" do

    select "Credit card", from: "order_paytype"

    expect(page).to have_css('#order_credit_card_number')
    expect(page).to have_css('#order_expiration_date')

    click_button 'Place Order'

    expect(page).to have_content("Thank you for your order")

    order = Order.first

    expect(order.name).to eq("Mr Creed")
    expect(order.address).to eq("30 Speed Rd")
    expect(order.email).to eq("creede2@gmail.com")
    expect(order.paytype).to eq("Credit card")

    mail = ActionMailer::Base.deliveries.last

    expect(mail.to.first).to eq order.email
    expect(mail[:from].value).to eq "fakeshop <depot@example.com>"
    expect(mail.subject).to eq "Pragmatic Store Order Confirmation"
  end
end