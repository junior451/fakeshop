class StoreController < ApplicationController
  include CurrentCart
  before_action :set_counter, only: [:index]
  before_action :set_cart

  def index
    @products = Product.order(:title)
  end
end
