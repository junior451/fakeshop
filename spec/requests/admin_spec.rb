require 'rails_helper'

RSpec.describe "Admins", type: :request do
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
