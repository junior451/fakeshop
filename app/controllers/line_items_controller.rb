class LineItemsController < ApplicationController
  include CurrentCart

  before_action :set_cart, only: [:create, :decrement]

  def create
    product = Product.find(params[:product_id])
    @line_item = @cart.add_product(product)

    respond_to do |format|
      if @line_item.save
        session[:counter] = 0
        format.html { redirect_to store_index_url }
        format.js { @current_item = @line_item }
        format.json { render :show, status: :created, location: @line_item }
      else
        format.html { render :new }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  def decrement
    line_item = LineItem.find(params[:id])

    if line_item.quantity == 1
      redirect_to store_index_url, notice: "Cannot decrement any further"
    else
      respond_to do |format|
        line_item.quantity = line_item.quantity - 1
        line_item.save

        format.js do 
          render  :template => "line_items/create.js.erb", :layout => false
        end

        format.html { redirect_to store_index_url }
      end
      
    end
  end

  def destroy
    line_item = LineItem.find(params[:id])
    title = line_item.product.title

    respond_to do |format|
      if line_item.destroy
        format.html { redirect_to store_index_url, notice: "Your item #{title} has been destroyed" }
        format.json { head :no_content }
      end  
    end
  end
end
