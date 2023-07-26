require 'rails_helper'

RSpec.describe 'Create Product', type: :system do
  it "allows new products to be created" do
    login
    
    visit products_path

    click_link 'New Product'

    fill_in 'Title', with: 'Ruby on Rails Guide'
    fill_in 'Description', with: 'Ruby on Rails Guide to improve expertise'
    fill_in 'Image url', with: 'crystal.jpg'
    fill_in 'Price', with: 30

    click_button 'Create Product'

    product = Product.first

    expect(page.body).to include("Product was successfully created.")
    expect(product.title).to eq('Ruby on Rails Guide')
    expect(product.description).to eq('Ruby on Rails Guide to improve expertise')
    expect(product.image_url).to eq('crystal.jpg')
    expect(product.price).to eq 30
  end
end