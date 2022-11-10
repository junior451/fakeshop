require 'rails_helper'

RSpec.describe "Products", type: :request do
  describe "GET /index" do
    it "assigns all products" do
      product = create(:product)

      get "/products"

      expect(assigns(:products)) == ([product])
    end

    it "should render the index template" do
      create(:product)
      get "/products"

      expect(response).to render_template("index")
      expect(response.body).to include("Programming Crystal")
      expect(response.body).to include("Crystal is for Ruby programmers who want more performance")
    end

    it "returns the correct response" do
      get "/products"
      expect(response).to have_http_status(200)
    end
  end

  describe "create new products " do
    before do
      get "/products/new"
    end

    it "should render the new template" do
      expect(response).to render_template("new")
    end

    context "with correct products data" do
      it "should create a new product based on data submitted through form" do
        post "/products", :params => {:product  =>{:title => "test product", :description => "this is a desc", :image_url => "ruby.jpg", :price =>"33.00"} }
  
        expect(response).to redirect_to(assigns(:product))
        follow_redirect!
        
        expect(response).to render_template("show")
        expect(response.body).to include("test product")
        expect(response.body).to include("Product was successfully created.")
        expect(response).to have_http_status(200)
      end
    end

    context "with incorrect products data" do
      it "re-render the new template and display errors" do
        post "/products", :params => {:product  =>{:title => nil, :description => nil, :image_url => nil, :price => nil} }

        expect(response).to render_template("new")

        errors = ["Title can't be blank", "Description can't be blank", "Image url can't be blank", "Price is not a number"]

        errors.each do |error|
          expect(CGI.unescapeHTML(response.body)).to include(error)
        end
      end
    end
  end

  describe "edit an existing product" do
    let(:product) { create(:product) }

    before do
      get "/products/#{product.id}/edit"
    end

    it "should render the edit page" do
      expect(response).to render_template("edit")
    end

    it "should update the product" do
      put "/products/#{product.id}", :params => {:product  =>{:title => "updated title"} }

      expect(response).to redirect_to(assigns(:product))
      follow_redirect!
      
      expect(response).to render_template("show")
      expect(response.body).to include("updated title")
      expect(response.body).to include("Product was successfully updated.")
      expect(response).to have_http_status(200)
    end
  end

  describe "delete an exisiting" do
    let(:product) { create(:product) }

    it "should delete a product based on its id" do
      delete "/products/#{product.id}"

      follow_redirect!
      
      expect(response.body).to include("Product was successfully destroyed.")
      expect(Product.count).to eq 0
    end
  end
end
