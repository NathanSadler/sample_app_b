module FillInForms
  def fill_in_user_form(session, name, email, password, password_confirmation = nil)
    session.fill_in 'Name', with: name
    session.fill_in 'Email', with: email
    session.fill_in 'Password', with: password
    if password_confirmation.nil?
      session.fill_in 'Password Confirmation'
    end
  end
end