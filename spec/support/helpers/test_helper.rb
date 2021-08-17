module TestHelper
  def log_in_user(user, password: 'password', remember_me: '1')
    post login_path, params: { session: { email: user.email, password: password, remember_me: remember_me}}
  end

  def visit_login_page(session)
    session.visit("/login")
  end

  
end