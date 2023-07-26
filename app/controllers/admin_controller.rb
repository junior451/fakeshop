class AdminController < ApplicationController
  before_action :authorize

  def home
    @total_orders = Order.unshipped.count
  end
end