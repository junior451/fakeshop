module PaymentTypes
  class CreditCard
    def make_payment(order_id, payment_details)
      payed_info = "Processing credit card with cc_no: #{payment_details[:cc_no]} and expiration_date: #{payment_details[:expiration_date]} for order_no #{order_id}"

      Rails.logger.info(payed_info)
    end
  end
end  