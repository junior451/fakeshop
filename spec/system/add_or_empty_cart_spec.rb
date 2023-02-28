require 'rails_helper'

RSpec.describe 'Add or Empty cart', type: :system do
  it "shows the cart when a product is added to a cart" do
    product = create(:product)

    visit store_index_path

    within('#cart') do
      expect(page).to_not have_css('article')
    end

    click_button "Add to Cart"

    within('#cart') do
      expect(page).to have_css('article')
    end

    expect(page.body).to include("Your Cart")
  end

  it "removes the cart when the empty cart button is clicked" do
    product = create(:product)

    visit store_index_path

    click_button "Add to Cart"

    within('#cart') do
      expect(page).to have_css('article')
    end

    click_button "Empty cart"

    within('#cart') do
      expect(page).to_not have_css('article')
    end
  end
end