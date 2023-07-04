require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  it "is valid with valid attributes" do
    expect(user).to be_valid
  end

  it "is invalid without a username" do
    user.username = ""

    expect(user).to_not be_valid
  end

  it "is invalid without a password" do
    user = build(:user, password: "")

    expect(user).to_not be_valid
  end

  it "is invalid when the username already exist" do
    user.save

    user2 = build(:user, username: user.username)

    user2.save

    expect(user2.errors.full_messages.first).to eq("Username has already been taken")
    
    expect { create(:user, username: user.username) }.to raise_error (ActiveRecord::RecordInvalid)
  end
end
