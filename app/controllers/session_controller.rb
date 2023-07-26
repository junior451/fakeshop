class SessionController < ApplicationController
  def new
  end

  def create
    user = User.find_by(username: login_params[:username])

    respond_to do |format|
      if user&.authenticate(login_params[:password])
        session[:user_id] = user.id
        
        format.html { redirect_to admin_url, notice: 'Successfully logged In' }
        format.json { render json: { message: "Logged In as admin" }, status: 200 }
      else
        format.html { redirect_to login_url, alert: "Invalid username or password"}
        format.json { render json: { message: "Login Successfully" }, status: 401 }
      end
    end
  end

  def logout
    session[:user_id] = nil
    redirect_to login_url, notice: "logged out"
  end

  private

  def login_params
    params.permit(:username, :password)
  end
end