class SessionsController < ApplicationController
  before_action :require_user, only: [:destroy]

  def new
    redirect_to home_path if logged_in?
  end

  def create
    user = User.find_by email: params[:email]

    if user && user.authenticate(params[:password])
      # session[:user_id] = user.id
      log_in(user)
      flash[:info] = "You are signed in, enjoy!"
      redirect_to home_path
    else
      flash.now[:danger] = "Incorrect email or password. Please try again."
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:info] = "You are signed out."
    redirect_to root_path
  end
end
