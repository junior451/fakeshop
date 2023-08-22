require 'rails_helper'

RSpec.describe 'Delete Users', type: :system do

  it "allows a user to be deleted" do
    login
    
    user = create(:user, username: "user4")

    click_link "Users"

    expect(page.body).to include("user4")
    expect(User.second.username).to eq("user4")
    
    find(:xpath, "(//a[text()='Delete'])[1]").click

    
    expect(page.body).to_not include("user4")
    expect(User.count).to eq(1)
    expect(User.first.username).to_not eq("user4")
  end

  context "when one one user exists" do
    it "doesn't allow the user to be deleted" do
      login

      click_link "Users"

      find(:xpath, "(//a[text()='Delete'])[1]").click

      expect(page.body).to include("Cant delete last user")
      expect(page.body).to include(User.first.username)
      expect(User.count).to eq 1
    end
  end
end