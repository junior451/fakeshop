class AdminController < ApplicationController
  def home
    @total_orders = Order.unshipped.count
  end
end
