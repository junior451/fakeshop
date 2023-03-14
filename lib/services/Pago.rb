require 'ostruct'

class Services::Pago
  def make_payment(order_id, payment_type, payment_info)
    payment_type.make_payment(order_id, payment_info)

    sleep 3 unless Rails.env.test?

    Rails.logger.info "Done Processing Payment for order #{order_id}"

    OpenStruct.new(succeeded: true)
  end
end