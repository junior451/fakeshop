require 'rails_helper'

RSpec.describe "Users", type: :request do
  context "when not logged in" do
    it "redirects do the login page when trying to access the products page" do
      get users_path

      expect(response).to redirect_to(login_url)

      follow_redirect!

      expect(response.body).to include("Please Log In")
    end
  end

  context "when logged in" do
    before do
      login
    end

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
          expect(User.count).to eq 2
          expect(User.second.username).to eq("username_23")
        end
    
        it "redirects to the admin home page" do
          expect(response).to redirect_to(admin_url)
        end
    
    
        it "renders the correct response body" do
          create(:order, ship_date: nil)
          follow_redirect!
  
          expect(response.body).to include("Welcome Admin")
    
          total_no_unshipped_orders = Order.unshipped.count
          expect(response.body).to include("We have #{total_no_unshipped_orders} order")
        end
      end
      
      context "when username already exists" do
        before do
          invalid_user_info = { user: { username: User.first.username, password: User.first.password } }
  
          post "/users", params: invalid_user_info
        end
  
        it "doesn't create a new user and it notifies the user to use another username" do
          expect(response.body).to include("Username has already been taken")
          expect(User.count).to eq 1
        end
  
        it "renders the new page" do
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
  
    describe "edit" do
      it "should render the correct template" do
        user = create(:user, username: "user1")
  
        get edit_user_path(user)
        
        expect(response).to render_template("edit")
        expect(response.status).to eq(200)
      end
    end
  
    describe "editing a user's username" do
      context "when the new username doesn't already exist" do
        let(:user) { create(:user, username: "user1") }
        let(:valid_params) { { user: { username: "new_username" } } }
    
        before do
          put "/users/#{user.id}", params: valid_params
        end
  
        it "changes the username of the user" do
          expect(User.second.username).to eq("new_username")
        end
  
        it "redirects to users page" do
          expect(response).to redirect_to("/users")
  
          follow_redirect!
  
          expect(response.body).to include(User.first.username)
        end
  
        it "response with the correct status" do
          follow_redirect!
  
          expect(response.status).to eq(200)
        end
      end
  
      context "when the username already exist" do
        it "doesn't change the username and responds with an error message" do
          user2 = create(:user, username: "user21")
  
          put "/users/#{user2.id}", params: { user: { username: User.first.username } }
  
          expect(response).to render_template(:edit)
          expect(response.body).to include("Username has already been taken")
          expect(User.second.username).to eq(user2.username)
          expect(response.status).to eq(422)
        end
      end
    end

    describe "updating a user's password" do
      let(:user) { create(:user, username: "new_user") }

      context "when current password is provided" do
        it "allows the password to be changed" do
          #expect { put "/users/#{user.id}/password_update", params: {user: { current_password: "my_password", new_password: "new_password" }} }.to change(user, :password).to "new_password"

          put "/users/#{user.id}/password_update", params: {user: { current_password: "my_password", new_password: "new_password" }}

          expect(response).to redirect_to(users_path)

          follow_redirect!

          expect(response.body).to include("Password for user#{user.id} was changed")
        end
      end

      context "when current password is not provided" do
        it "re renders the edit password page with errors" do
          put "/users/#{user.id}/password_update", params: {user: { current_password: "", new_password: "new_password" }}

          expect(response).to redirect_to(edit_password_user_path)

          follow_redirect!
  
          expect(response).to render_template(:edit_password)
          expect(response.body).to include("Current password not provided or incorrect")
        end
      end

      context "when current password is incorrect" do
        it "re renders the edit password page with errors" do
          put "/users/#{user.id}/password_update", params: {user: { current_password: "incorrect_password", new_password: "new_password" }}

          expect(response).to redirect_to(edit_password_user_path)

          follow_redirect!
  
          expect(response).to render_template(:edit_password)
          expect(response.body).to include("Current password not provided or incorrect")
        end
      end
    end

  
    describe "deleting a user" do
      let(:users) {
        build_list(:user, 2) do |record,i| 
          record.username = record.username + i.to_s
          record.save!
        end
      }
  
      it "removes the user from the database and redirects to the users page" do
        delete "/users/#{users[0].id}"
  
        expect(response).to redirect_to(users_path)
  
        follow_redirect!
  
        expect(User.count).to eq 2
        expect(response.body).to_not include(users[0].username)
        expect(response.status).to eq 200
      end
  
      context "when the user doesn't exist" do
        it "redirects to the users page with an error message" do
          delete "/users/1"
  
          expect(response).to redirect_to(users_path)
  
          follow_redirect!
  
          expect(response.body).to include("User cannot be found")
          expect(response.status).to eq 200
        end
      end
  
      context "when there only one user exist" do
        it "should not delete the user and respond with a message" do
          delete "/users/#{User.first.id}"
  
          expect(response).to redirect_to(users_path)
  
          follow_redirect!
  
          expect(response.body).to include("Cant delete last user")
          expect(User.count).to eq(1)
        end
      end
    end
  end
end
