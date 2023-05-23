# Preview all emails at http://localhost:3000/rails/mailers/errors
class ErrorsPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/errors/invalid_cart
  def invalid_cart
    ErrorsMailer.invalid_cart
  end

end
