require 'rails_helper'

RSpec.describe 'Logging in as admin', type: :system do
  it "allows users to logging as admin after their account has been created" do
    user  = create(:user)

    order = create(:order, ship_date: nil)
    product = create(:product)

    create(:line_item, product_id: product.id, order_id: order.id, quantity: 3)
  
    visit login_path

    fill_in "Username", with: user.username
    fill_in "Password", with: user.password

    click_button "Login"

    expect(page).to have_http_status 200
    expect(page.body).to include("Successfully Logged In")
    expect(page.body).to include("Welcome Admin")
    expect(page.body).to include("We have 1 order")
  end
  
  context "when user doesnt exist" do
    it "doesn't login and sends an invalid user notice" do
      visit login_path
      
      fill_in "Username", with: "Invalid User"
      fill_in "Password", with: "Invalid password"

      click_button "Login"
      
      expect(page.current_path).to eq login_path
      expect(page.body).to include("Invalid username or password")
    end
  end
end