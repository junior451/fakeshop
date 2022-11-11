require 'rails_helper'

RSpec.describe "Store", type: :request do
  describe "GET / " do

    it "assigns the products variable" do
      product = create(:product) 

      get "/"

      expect(assigns(:products)) == ([product])
    end

    it "renders the correct template" do
      product = create(:product)

      get "/"

      expect(response).to render_template("index")
      expect(response.body).to include(product.title)
      expect(response.body).to include(product.description)
    end

    it "returns http success" do
      get "/"
      expect(response).to have_http_status(:success)
    end
  end
end
