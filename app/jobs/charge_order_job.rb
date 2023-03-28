class ChargeOrderJob < ApplicationJob
  queue_as :default

  def perform(order, paytype_params)
    order.charge!(paytype_params)
  end
end
