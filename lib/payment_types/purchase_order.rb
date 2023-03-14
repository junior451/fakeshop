module PaymentTypes
  class PurchaseOrder
    def make_payment(order_id, payment_details)
      payed_info = "Processing Purchase order with po_no: #{payment_details[:po_no]} for order_no #{order_id}"

      Rails.logger.info(payed_info)
    end
  end
end  