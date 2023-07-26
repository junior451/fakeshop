class ApplicationController < ActionController::Base

  private

  def authorize
    unless User.find_by(id: session[:user_id])
      redirect_to login_url
    end
  end
end
