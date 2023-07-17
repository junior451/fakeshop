class User < ApplicationRecord
  after_destroy :ensure_an_admin_remains

  has_secure_password

  validates :username, presence: true, uniqueness: true

  class Error < StandardError
  end

  private

  def ensure_an_admin_remains
    if User.count == 0
      raise Error.new("Cant delete last user")
    end
  end
end
