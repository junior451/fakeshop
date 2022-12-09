class LineItemsController < ApplicationController
  include CurrentCart

  before_action :set_cart, only: [:create]

  def create
    product = Product.find(params[:product_id])
    @line_item = LineItem.new(product_id: product.id, cart_id: @cart.id)

    respond_to do |format|
      if @line_item.save
        session[:counter] = 0
        format.html { redirect_to @line_item.cart,
          notice: 'Line item was successfully created.' }
        format.json { render :show, status: :created, location: @line_item }
      else
        format.html { render :new }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end
end
