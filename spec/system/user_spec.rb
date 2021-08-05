require 'rails_helper'

RSpec.describe "User", type: :system do
  fixtures :users
  let(:user) {users(:michael)}
  let(:session) {Capybara::Session.new(:rack_test, Rails.application)}

  describe("user trying to update a user") do
    it("keeps the user on the update user page if their update is unsuccessful") do
      session.visit(login_path)
      submit_login_form(session: session, email: user.email, password: user.password)
      session.visit(edit_user_path(user))
      submit_user_form(session: session, name: " ", email:"foo@invalid", password:"foo", password_confirmation: "bar", 
        button_text: "Save Changes")
      expect(session.current_path).to(eq("/users/#{user.id}"))
    end
  end
end