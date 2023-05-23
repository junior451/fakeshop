class ErrorsMailer < ApplicationMailer
  default from: 'fakeshop <depot@example.com>'

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.errors_mailer.invalid_cart.subject
  #
  def invalid_cart(error_message)
    @message = error_message

    mail to: "user1@example.com", subject: 'System Error Invalid cart'
  end
end
