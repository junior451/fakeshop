require 'rails_helper'

RSpec.describe 'Edit Product', type: :system do
  it "allows product details to be edited" do
    login
    
    product = create(:product)

    visit products_path

    click_link 'Edit'

    fill_in 'Title', with: 'Ruby on Rails gude'
    fill_in 'Description', with: 'Ruby on Rails Guide to improve expertise' 
    fill_in 'Price', with: 12.0

    click_button 'Update Product'

    expect(page.body).to include('Ruby on Rails gude')
    expect(page.body).to include('Ruby on Rails Guide to improve expertise' )
    expect(page.body).to include('12.0')
  end
end