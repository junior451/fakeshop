# Preview all emails at http://localhost:3000/rails/mailers/order
class OrderPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/order/received
  def received
    OrderMailer.received
  end

  # Preview this email at http://localhost:3000/rails/mailers/order/shipped
  def shipped
    OrderMailer.shipped
  end

end
