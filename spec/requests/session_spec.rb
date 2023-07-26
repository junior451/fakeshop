require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe "GET /login" do
    it "should render the new template" do
      get "/login"
      expect(response).to render_template(:new)
    end

    it "returns http success" do
      get "/login"
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /login" do
    it "should autheticate user and redirect to the admin page" do
      login_with_valid_user

      expect(response).to redirect_to(admin_url)

      follow_redirect!

      expect(response.body).to include("Successfully logged In")
      expect(response.body).to include("Welcome Admin")
      expect(response.status).to eq 200
    end

    context "with invalid username or password" do
      it "should redirect to the login page with an error message" do
        invalid_params = { username: "invalid_username", password: "my_password" }

        post "/login", :params => invalid_params

        expect(response).to redirect_to login_path

        follow_redirect!

        expect(response.body).to include("Invalid username or password") 
      end
    end
  end


  describe "logout" do
    it "should destroy the current session and rediret to login path" do
      login_with_valid_user

      expect(session[:user_id]).to eq User.first.id
      
      delete "/logout"

      expect(session[:user_id]).to be_nil
      expect(response).to redirect_to(login_url)
    end
  end

  def login_with_valid_user
    user = create(:user)
    valid_params = { username: user.username, password: "my_password" }
    post "/login", :params => valid_params
  end

end
