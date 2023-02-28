require 'rails_helper'

RSpec.describe 'Delete Product', type: :system do
  it "allows products to be deleted" do
    product = create(:product)

    visit products_path

    click_link "Destroy"

    expect(page.body).to include("Product was successfully destroyed.")
    expect(Product.first).to be_nil
  end
end