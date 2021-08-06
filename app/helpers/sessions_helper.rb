module SessionsHelper
  # Logs in the given user
  def log_in(user)
    session[:user_id] = user.id
    # Guard against session replay attacks.
    # See https://bit.ly/33UvK0w for more.
    session[:session_token] = user.session_token

  end

  # Returns the user corresponding to the remember token cookie.
  def current_user
    # basically 'if session id exists'
    # binding.pry
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    # Gets users from temporary session if cookies[:user_id] exists and is logged in
    elsif (user_id = cookies.encrypted[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
    # if session[:user_id]
    #   @current_user ||= User.find_by(id: session[:user_id])
    # end
  end

  def current_user?(user)
    user && user == current_user
  end

  def remember(user)
    user.remember
    cookies.permanent.encrypted[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def logged_in?
    !current_user.nil?
  end

  # forgets a persistent session
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # Logs out the current user
  def log_out
    forget(current_user)
    reset_session
    @current_user = nil
  end
end
