# == Schema Information
#
# Table name: orders
#
#  id         :bigint           not null, primary key
#  name       :string
#  address    :text
#  email      :string
#  paytype    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Order < ApplicationRecord
  has_many :line_items, dependent: :destroy

  enum paytype: {
    "Check" => 0,
    "Credit card" => 1,
    "Purchase order" => 2
  }

  validates :name, :address, :email, :paytype, presence: true
  validates :paytype, inclusion: paytypes.keys

  def add_line_items_from_cart(cart)
    cart.line_items.each do |item|
      item.cart_id = nil
      line_items << item
    end
  end

  def get_product_item(product)
    line_items.where(product_id: product.id).first
  end

  def charge!(paytype_params)
    payment_info = {}
    payment_method = nil

    case paytype
    when "Check"
      payment_info[:routing_no] = paytype_params[:routing_number]
      payment_info[:account_no] = paytype_params[:account_number]

      payment_type = PaymentTypes::Check.new
      
    when "Credit card"
      payment_info[:cc_no] = paytype_params[:credit_card_number]
      payment_info[:expiration_date] = paytype_params[:expiration_date]

      payment_type = PaymentTypes::CreditCard.new
    when "Purchase order"
      payment_info[:po_no] = paytype_params[:po_number]
    end

    payment_result = Services::Pago.new.make_payment(id, payment_type, payment_info)

    if payment_result.succeeded
      OrderMailer.received(self).deliver_later
    else
      Rails.logger.info("payment error")
    end
  end
end
