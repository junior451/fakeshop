require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "new" do
    before do
      get "/users/new"
    end

    it "renders the new page" do
      expect(response).to render_template(:new)
    end

    it "assigns a new user" do
      expect(assigns(:user)).to be_instance_of(User)
    end

    it "returns the correct successful response" do
      expect(response.status).to eq(200)
    end
  end

  describe "creating a new user" do
    context "when the username doesn't already exist" do
      let(:valid_user) { { user: { username: "username_23", password: "my_password" } } }
      
      before do
        post "/users", params: valid_user
      end

      it "creates a new user" do
        expect(User.count).to eq 1
        expect(User.first.username).to eq("username_23")
      end
  
      it "redirects to the admin home page" do
        expect(response).to redirect_to(admin_url)
      end
  
  
      it "renders the correct response body" do
        create(:order, ship_date: nil)
        follow_redirect!

        expect(response.body).to include("Welcome Admin")
  
        total_unshipped_order = Order.where(ship_date: nil).count
        expect(response.body).to include("We have #{total_unshipped_order} order")
      end
    end
    
    context "when username already exists" do
      let(:user)  { create(:user) }

      it "doesn't create a new user and it notifies the user to use another username" do
        invalid_user_info = { user: { username: user.username, password: "my_password" } }

        post "/users", params: invalid_user_info

        expect(response.body).to include("Username has already been taken")
        expect(User.count).to eq 1
      end

      it "renders the new page" do
        invalid_user_info = { user: { username: user.username, password: "my_password" } }

        post "/users", params: invalid_user_info

        expect(response).to render_template(:new)
      end
    end
  end

  describe "users list page" do
    unless metadata[:skip_before]
      before do
        get users_url
      end
    end

    it "returns a successful response" do
      expect(response.status).to eq(200)
    end

    it "assigns to users ordered by name" do
      expect(assigns[:users]).to eq(User.order(:username))
    end

    it "renders the index page", skip_before: true do
      users = build_list(:user, 2) do |user_record, i|
        user_record.username = "user#{i}"
        user_record.save!
      end

      get users_url

      expect(response).to render_template(:index)
      expect(response.body).to include("Users")
      expect(response.body).to include(users.first[:username])
      expect(response.body).to include(users.last[:username])
    end
  end
end