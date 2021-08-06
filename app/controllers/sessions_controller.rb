class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      forwarding_url = session[:forwarding_url]
      # Log user in and redirect to user's show page
      reset_session
      # binding.pry
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      # remember(user)
      log_in user
      redirect_to forwarding_url || user
      # redirect_to user
    else
      # Create an error message
      flash.now[:danger] = "Invalid email/password combination"
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
