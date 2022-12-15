class CartsController < ApplicationController
  before_action :set_cart, only: [:show, :destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :invalid_cart

  def show
    redirect_to store_index_url, notice: 'Authorised Cart' if @cart.id != session[:cart_id] 
  end

  def destroy
    @cart.destroy if @cart.id == session[:cart_id]
    session[:cart_id] = nil

    respond_to do |format|
      format.html { redirect_to store_index_url, notice: 'Your cart is empty' }
      format.json { head :no_content }
    end
  end

  private

  def invalid_cart
    logger.error("Attempt to access invalid cart #{params[:id]}")
    redirect_to(store_index_url, notice: 'Invalid cart')
  end

  def set_cart
    @cart = Cart.find(params[:id])
  end
end
