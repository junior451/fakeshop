require 'rails_helper'

RSpec.describe 'Create new user', type: :system do
  it "allows new users to be created" do
    login

    click_link "Users"
    click_link "New User"

    fill_in "Username", with: "user4"
    fill_in "Password", with: "password3"
    fill_in "Password confirmation", with: "password3"

    click_button "Create User"
    
    expect(page.body).to include("user4 was successfully created")
    expect(page.body).to include("Welcome Admin")

    click_link "Users"

    expect(page.body).to include("user4")
  end
end