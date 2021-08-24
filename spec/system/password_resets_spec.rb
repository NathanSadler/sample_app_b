require 'rails_helper'
require_relative '../helpers/users_helper_spec'

RSpec.describe 'PasswordResets', type: :system do
  fixtures :users
  let(:user) {User.find_by(name: users(:michael).name)}
  let(:session) {Capybara::Session.new(:rack_test, Rails.application)}

  before(:each) do
    ActionMailer::Base.deliveries.clear
    session.visit(new_password_reset_path)
  end

  context 'requesting a password reset' do
      # Uses the 'invalid email' section of listing 12.19 in the ruby on rails tutorial
    context 'using an invalid email' do
      before(:each) do
        request_password_reset(session: session, email: "")
      end

      it('generates a flash') do
        expect(session.find_all('div.alert.alert-danger').length).to be > 0
      end

      it("keeps users on the form to request a password reset") do
        expect(session.current_path).to(eq('/password_resets'))
      end
    end
    
    # Uses the 'valid email' section of listing 12.19 in the ruby on rails tutorial
    context 'with a valid email address' do
      before(:each) do
        request_password_reset(session: session, email: user.email)
      end

      it("changes the user's reset digest") do
        expect{request_password_reset(session: session, email: user.email)}.to change{User.find_by(name: user.name).reset_digest}
      end

      it('sends an email') do
        expect(ActionMailer::Base.deliveries.size).to(eq(1))
      end

      it('generates a flash message telling the user a password reset email was sent') do
        expected_message = 'Email sent with password reset instructions'
        expect(session.find('div.alert.alert-info').text).to(eq(expected_message))
      end

      it('directs the user to the home page') do
        expect(session.current_path).to(eq('/'))
      end
    end
  end

   # Uses the sections from 'wrong email' to 'right email, wrong token' of listing 12.19 in the ruby on rails tutorial
  context 'trying to go to the password reset form' do
    before(:each) do
      request_password_reset(session: session, email: user.email)
    end

    it('returns users to the root path if they are using the wrong email') do
      session.visit(edit_password_reset_path(user.reset_token, email: "", id: user.id))
      expect(session.current_path).to(eq('/'))
    end

    it('returns users to the root path if their account is not activated yet') do
      user.toggle!(:activated)
      session.visit(edit_password_reset_path(user.reset_token, email: user.email, id: user.id))
      expect(session.current_path).to(eq('/'))
    end

    it('returns users to the root path if they have the right email and the wrong token') do
      session.visit(edit_password_reset_path("wrong token", email: user.email, id: user.id))
      expect(session.current_path).to(eq('/'))
    end

    it('takes users to the password reset form if both the email and token are correct') do
      session.visit(edit_password_reset_path(user.reset_token, email: user.email, id: user.id))
      expect(session.current_path).to(eq('/password_resets/edit'))
    end
  end
end
