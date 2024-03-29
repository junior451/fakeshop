class OrdersController < ApplicationController
  include CurrentCart
  before_action :authorize, only: [:index]
  before_action :set_cart, only: [:new, :create]
  before_action :ensure_cart_isnt_empty, only: :new
  before_action :set_order, only: [:update]

  def index
    @orders = Order.all
  end

  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    @order.add_line_items_from_cart(@cart)

    respond_to do |format|
      if @order.save
        Cart.destroy(session[:cart_id])
        session[:cart_id] = nil
        ChargeOrderJob.perform_later(@order, paytype_params.to_h)
        format.html { redirect_to store_index_url, notice: 'Thank you for your order' }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new }
        format.json { render :json, @order.errors, status: :unprocessable_entity }
      end
    end
  end  


  def update
    respond_to do |format|
      if @order.update(shipdate_params)
        OrderMailer.shipped(@order).deliver_later
        format.html { redirect_to orders_url, notice: "Order ##{@order.id} has been shipped and shipping date has been updated" }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { redirect_to orders_url, notice: "Order wasn't successfully shipped" }
        format.json { render :json, @order.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:name, :address, :email, :paytype)
  end

  def paytype_params
    if(order_params[:paytype] == "Credit card")
      params.require(:order).permit(:credit_card_number, :expiration_date)
    elsif(order_params[:paytype] == "Check")
      params.require(:order).permit(:routing_number, :account_number)
    elsif(order_params[:paytype] == "Purchasing order")
      params.require(:order).permit(:po_number)
    end
  end

  def shipdate_params
    params.require(:order).permit(:ship_date)
  end

  def ensure_cart_isnt_empty
    if @cart.line_items.empty?
      redirect_to store_index_url, notice: "Your cart is empty"
    end
  end

end
