require 'rails_helper'

RSpec.describe 'Edit Users', type: :system do

  it "allows usernames to be editted" do
    login

    user = create(:user, username: "user4")

    click_link "Users"

    expect(page.body).to include("user4")
    expect(User.second.username).to eq("user4")
    
    find(:xpath, "(//a[text()='Edit'])[1]").click    
    
    fill_in "User", with: "user43"

    click_button "Update User"

    expect(page.body).to include("user43")
    expect(User.second.username).to eq("user43")
  end
end