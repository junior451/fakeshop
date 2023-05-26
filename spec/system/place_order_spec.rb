require 'rails_helper'

RSpec.describe 'Place Order', type: :system, js: true do
  before do
    add_to_cart_and_fill_in_basic_order_details
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

  it "allows the order details to be filled and submitted and sends an order confirmation email to the user " do

    select "Credit card", from: "order_paytype"

    expect(page).to have_css('#order_credit_card_number')
    expect(page).to have_css('#order_expiration_date')

    fill_in "CC", with: "1323444"
    fill_in "Expiry", with: "333563336"

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

  context "when user fails to input their payment details" do
    it "notifies the user about the error whilst processing payment" do
      select "Credit card", from: "order_paytype"

      fill_in "CC", with: ""
      fill_in "Expiry", with: ""

      click_button 'Place Order'

      expect(page).to have_content("Thank you for your order")

      order = Order.first

      mail = ActionMailer::Base.deliveries.last

      expect(mail.to.first).to eq(order.email)
      expect(mail.from.first).to eq("depot@example.com")
      expect(mail.subject).to eq("Failed to process payment info")
      expect(mail.body.encoded).to include("The payment failed to process for order_no #{order.id}")
      expect(mail.body.encoded).to include("Double check and enter your details again")
    end
  end

  def add_to_cart_and_fill_in_basic_order_details
    product = create(:product)

    visit store_index_path

    expect(page).to have_content(product.title)

    click_button 'Add to Cart'
    click_button 'Checkout'

    fill_in 'Name', with: 'Mr Creed'
    fill_in 'Address', with: '30 Speed Rd'
    fill_in 'Email', with: 'creede2@gmail.com'
  end
end