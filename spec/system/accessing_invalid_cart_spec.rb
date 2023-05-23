require 'rails_helper'

RSpec.describe 'Accessing Invalid cart', type: :system do
  before do
    product = create(:product)
  
    visit store_index_path
  end

  it "gives an invalid cart notification and redirect to the store index page" do
    visit "/carts/5"

    expect(page.body).to include("Invalid cart")
    expect(current_path).to eq("/")
  end

  it "sends an application error email to the user" do
    expect_any_instance_of(ErrorsMailer).to receive(:invalid_cart).with("Attempt to access an invalid cart gave an error")

    visit "/carts/5"
  end

  it "delivers the email to the user" do
    expect { visit "/carts/5" }.to change { ActionMailer::Base.deliveries.count }.by(1)
  end
end