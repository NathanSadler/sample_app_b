module FillInForms
  def fill_in_user_form(session, name, email, password, password_confirmation = nil)
    session.fill_in 'Name', with: name
    session.fill_in 'Email', with: email
    session.fill_in 'Password', with: password
  end

  def submit_user_form(session:, name:, email:, password:, button_text:, password_confirmation: nil)
  fill_in_user_form(session, name, email, password, password_confirmation = nil)
    session.click_on(button_text)
  end

  def fill_in_login_form(session:, email:, password:, remember_me: false)
    session.fill_in 'Email', with: email
    session.fill_in 'Password', with: password
  end

  def submit_login_form(session:, email:, password:, remember_me: false)
    fill_in_login_form(session: session, email: email, password: password)
    session.check("Remember me on this computer") if remember_me
    session.click_on("Log In")
  end
end