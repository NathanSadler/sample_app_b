class ApplicationController < ActionController::Base
  include SessionsHelper

  private
  # might want to remove logged_in_user from the Users controller if this causes any problems
  def logged_in_user
    if !logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end
end
