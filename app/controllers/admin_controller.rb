class AdminController < ApplicationController
  def home
    @total_orders = Order.where(ship_date: nil).count
  end
end
