module PaymentTypes
  class Check
    def make_payment(order_id, payment_details)
      return false if payment_details[:routing_no].empty? || payment_details[:account_no].empty?

      payed_info = "Processing check with routing_no: #{payment_details[:routing_no]} and account_no: #{payment_details[:account_no]} for order_no #{order_id}"

      Rails.logger.info(payed_info)
    end
  end
end