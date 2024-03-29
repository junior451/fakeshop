class UsersController < ApplicationController
  before_action :authorize
  before_action :set_user, only: [:edit, :update, :destroy, :edit_password, :password_update]

  def index
    @users = User.order(:username)
  end

  def new
    @user = User.new
  end

  def show
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to admin_path, notice: "#{@user.username} was successfully created" }
        format.json { render json: @user, status: :created }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def edit_password
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to users_path, notice: "User#{@user.id} username was successfully updated to #{@user.username}" }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def password_update
    respond_to do |format|
      if @user.authenticate(password_params[:current_password])
        @user.update(password: password_params[:new_password])
        format.html { redirect_to users_path, notice: "Password for user#{@user.id} was changed" }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { redirect_to edit_password_user_path, notice: "Current password not provided or incorrect" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    begin
      respond_to do |format|
        if @user&.destroy
          format.html { redirect_to users_path, notice: "User has been successfully deleted" }
          format.json { head :no_content }
        else
          format.html { redirect_to users_path, notice: "User cannot be found" }
          format.json { render json: "User cannot be found", status: 404 }
        end
      end
    rescue User::Error => exception
      redirect_to users_url, notice: exception.message
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    @user = nil
  end

  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation)
  end

  def password_params
    params.require(:user).permit(:current_password, :new_password)
  end
end
