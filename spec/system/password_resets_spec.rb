require 'rails_helper'
require_relative '../helpers/users_helper_spec'

RSpec.describe 'PasswordResets', type: :system do
  fixtures :users
  let(:user) {users(:michael)}
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
    end
  end
end
