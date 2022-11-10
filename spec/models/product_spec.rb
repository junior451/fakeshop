require 'rails_helper'

RSpec.describe Product, type: :model do  
  let(:product) { build(:product) }

  it "is valid with attributes" do
    expect(product).to be_valid
  end

  it "is invalid without any attribitue" do
    product_no_attrs = build(:product, title: nil, description: nil, image_url: nil, price: nil )
    expect(product_no_attrs).to_not be_valid
  end

  it "is invalid without a title" do
    product.title = nil
    expect(product).to_not be_valid
    expect(product.errors.full_messages.first).to eq("Title can't be blank")
  end

  it "is invalid if title is less than 10" do
    product.title = "ruby book"
    expect(product).to_not be_valid
    expect(product.errors.full_messages.first).to eq("Title can't be less than 10 characters")
  end

  it "is invalid if the same title exists in the database" do
    create(:product)
    product.title = "Programming Crystal"
    expect(product).to_not be_valid
    expect(product.errors.full_messages.first).to eq("Title has already been taken")
  end

  it "is invalid without a description" do
    product.description = nil
    expect(product).to_not be_valid
    expect(product.errors.full_messages.first).to eq("Description can't be blank")
  end

  it "is invalid without an image url" do
    product.image_url = nil
    expect(product).to_not be_valid
    expect(product.errors.full_messages.first).to eq("Image url can't be blank")
  end

  context "price" do
    it "is invalid when price is 0" do
      product.price = 0
      expect(product).to_not be_valid
      expect(product.errors.full_messages.first).to eq("Price must be greater than or equal to 0.01")
    end

    it "is invalid when price is less than 0" do
      product.price = -1
      expect(product).to_not be_valid
      expect(product.errors.full_messages.first).to eq("Price must be greater than or equal to 0.01")
    end

    it "is invalid when price is not numerical" do
      product.price = "price"
      expect(product).to_not be_valid
      expect(product.errors.full_messages.first).to eq("Price is not a number")
    end

    it "is valid when price is greater than 0" do
      product.price = 1
      expect(product).to be_valid
    end
  end

  context "image url" do
    it "should end in .jgp, .png, .gif" do
      ok_urls = %w{ rails.gif rails.png rails.jpg }

      ok_urls.each do |image_url|
        product.image_url = image_url
        expect(product).to be_valid
      end
    end

    it "should should not end in any other format except .jpg, .png, .gif" do
      bad_urls = %w{ rails.more rails.doc rails.gif.more }

      bad_urls.each do |image_url|
        product.image_url = image_url
        expect(product).to_not be_valid
      end
    end
  end
end
