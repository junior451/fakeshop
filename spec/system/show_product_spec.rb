require 'rails_helper'

RSpec.describe 'Show Product', type: :system do
  it "shows the details of a speciific product" do
    login
    
    product = create(:product)

    visit products_path

    click_link "Show"

    expect(page.body).to include(product.title)
    expect(page.body).to include(product.description)
    expect(page.body).to include(product.image_url)
    expect(page.body).to include(product.price.to_s)
  end
end