require 'ostruct'

class Services::Pago
  def make_payment(order_id, payment_type, payment_info)
    result = payment_type.make_payment(order_id, payment_info)

    if result == false
      Rails.logger.info("Error Processing Payment for order_no #{order_id}")
      return OpenStruct.new(succeeded: false)
    end  
    
    sleep 3 unless Rails.env.test? 

    Rails.logger.info "Done Processing Payment for order_no #{order_id}"

    OpenStruct.new(succeeded: true)
  end
end