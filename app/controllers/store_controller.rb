class StoreController < ApplicationController
  include CurrentCart
  before_action :set_counter, only: [:index]

  def index
    @products = Product.order(:title)
  end
end
