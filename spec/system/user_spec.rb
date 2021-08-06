require 'rails_helper'

RSpec.describe "User", type: :system do
  fixtures :users
  let(:user) {users(:michael)}
  let(:session) {Capybara::Session.new(:rack_test, Rails.application)}

  before(:each) do
    session.visit(login_path)
    submit_login_form(session: session, email: user.email, password: user.password)
  end

  describe("user trying to update a user") do
    before(:each) do
      session.visit(edit_user_path(user))
    end

    it("keeps the user on the update user page if their update is unsuccessful") do
      submit_user_form(session: session, name: " ", email:"foo@invalid", password:"foo", password_confirmation: "bar", 
        button_text: "Save Changes")
      expect(session).to(have_content("Password is too short"))
    end

    describe("with valid information") do
      before(:each) do
        submit_user_form(session: session, name: "Foo Bar", email: "foo@bar.com", password: user.password, 
          button_text: "Save Changes")
      end

      it("moves the user to their profile page") do
        expect(session.has_no_button?("Save Changes")).to(be(true))
        expect(session.current_path).to(eq("/users/#{user.id}"))
      end

      it("updates their information") do
        expect(user.name).to(eq("Foo Bar"))
        expect(user.email).to(eq("foo@bar.com"))
      end
    end
  end
end