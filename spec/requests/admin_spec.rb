require 'rails_helper'

RSpec.describe "Admins", type: :request do
  context "when not logged In" do
    it "redirects do the login page when trying to access the products page" do
      get admin_path

      expect(response).to redirect_to(login_url)

      follow_redirect!

      expect(response.body).to include("Please Log In")
    end
  end

  context "when logged in" do
    describe "GET /home" do
      before do
        login
      end
  
      it "returns http success" do
        get "/admin/home"
  
        expect(response).to have_http_status(:success)
      end
    end
  end
end
