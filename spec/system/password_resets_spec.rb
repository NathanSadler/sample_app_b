require 'rails_helper'
require_relative '../helpers/users_helper_spec'

# RSpec.describe 'PasswordResets', type: :system do
#   fixtures :users
#   let(:user) {users(:michael)}
#   let(:session) {Capybara::Session.new(:rack_test, Rails.application)}

#   before(:each) do
#     ActionMailer::Base.deliveries.clear
#     session.visit(new_password_reset_path)
#   end

#   xcontext 'requesting a password reset' do
#       # Uses the 'invalid email' section of listing 12.19 in the ruby on rails tutorial
#     context 'using an invalid email' do
#       before(:each) do
#         request_password_reset(session: session, email: "")
#       end

#       it('generates a flash') do
#         expect(session.find_all('div.alert.alert-danger').length).to be > 0
#       end

#       it("keeps users on the form to request a password reset") do
#         expect(session.current_path).to(eq('/password_resets'))
#       end
#     end
    
#     # Uses the 'valid email' section of listing 12.19 in the ruby on rails tutorial
#     context 'with a valid email address' do
#       before(:each) do
#         request_password_reset(session: session, email: user.email)
#       end

#       it("changes the user's reset digest") do
#         expect{request_password_reset(session: session, email: user.email)}.to change{User.find_by(name: user.name).reset_digest}
#       end

#       it('sends an email') do
#         expect(ActionMailer::Base.deliveries.size).to(eq(1))
#       end

#       it('generates a flash message telling the user a password reset email was sent') do
#         expected_message = 'Email sent with password reset instructions'
#         expect(session.find('div.alert.alert-info').text).to(eq(expected_message))
#       end

#       it('directs the user to the home page') do
#         expect(session.current_path).to(eq('/'))
#       end
#     end
#   end

#    # Uses the sections from 'wrong email' to 'right email, wrong token' of listing 12.19 in the ruby on rails tutorial
#   xcontext 'trying to go to the password reset form' do
#     before(:each) do
#       request_password_reset(session: session, email: user.email)
#     end

#     it('returns users to the root path if they are using the wrong email') do
#       session.visit(edit_password_reset_path(user.reset_token, email: ""))
#       expect(session.current_path).to(eq('/'))
#     end

#     it('returns users to the root path if their account is not activated yet') do
#       user.toggle!(:activated)
#       session.visit(edit_password_reset_path(user.reset_token, email: user.email))
#       expect(session.current_path).to(eq('/'))
#     end

#     it('returns users to the root path if they have the right email and the wrong token') do
#       session.visit(edit_password_reset_path("wrong token", email: user.email))
#       expect(session.current_path).to(eq('/'))
#     end

#     it('takes users to the password reset form if both the email and token are correct') do
#       binding.pry
#       session.visit(edit_password_reset_path(@user.reset_token, email: user.email))
#       expect(session.current_path).to(eq('/password_resets/edit'))
#     end
#   end
# end

# Uses the sections from 'wrong email' to 'right email, wrong token' of listing 12.19 in the ruby on rails tutorial
RSpec.describe 'Help', type: :request do
  fixtures :users
  let(:user) {users(:michael)}

  it("just works") do
    get new_password_reset_path
    assert_template 'password_resets/new'
    assert_select 'input[name=?]', 'password_reset[email]'
    # Invalid email
    post password_resets_path, params: { password_reset: { email: "" } }
    assert_not flash.empty?
    assert_template 'password_resets/new'
    # Valid email
    post password_resets_path,
         params: { password_reset: { email: user.email } }
    assert_not user.reset_digest == user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url
    # Password reset form
    user = assigns(:user)
    # Wrong email
    get edit_password_reset_path(user.reset_token, email: "")
    assert_redirected_to root_url
    # Inactive user
    user.toggle!(:activated)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to root_url
    user.toggle!(:activated)
    # Right email, wrong token
    get edit_password_reset_path('wrong token', email: user.email)
    assert_redirected_to root_url
    # Right email, right token
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    assert_select "input[name=email][type=hidden][value=?]", user.email
    # Invalid password & confirmation
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password:              "foobaz",
                            password_confirmation: "barquux" } }
    assert_select 'div#error_explanation'
    # Empty password
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password:              "",
                            password_confirmation: "" } }
    assert_select 'div#error_explanation'
    # Valid password & confirmation
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password:              "foobaz",
                            password_confirmation: "foobaz" } }
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to user
  end
end