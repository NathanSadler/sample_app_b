require 'rails_helper'

RSpec.describe "UsersLogins", type: :request do
  describe "GET /users_logins" do
    fixtures :users

    let(:user) {users(:michael)}

    it "login with valid email/invalid password" do
      get login_path
      expect(request.path).to(eq('/login'))
      post login_path, params: {session: {email: user.email, password: ""}}
      expect(is_logged_in?).to(eq(false))
      expect(request.path).to(eq('/login'))
      expect(flash.empty?).to(eq(false))
      get root_path
      expect(flash.empty?).to(eq(true))
    end

    it "logs in with valid information followed by logout" do
      get login_path
      post login_path, params: { session: { email: user.email,
                                        password: 'password' } }
      assert_redirected_to user
      follow_redirect!
      assert_select "a[href=?]", login_path, count: 0
      assert_select "a[href=?]", logout_path
      assert_select "a[href=?]", user_path(user)
      delete logout_path
      assert_not is_logged_in?
      assert_redirected_to root_url
      delete logout_path
      follow_redirect!
      assert_select "a[href=?]", login_path
      assert_select "a[href=?]", logout_path,      count: 0
      assert_select "a[href=?]", user_path(user), count: 0
    end

    it "creates a remember token when the remember me box is selected" do
      log_in_user(user, remember_me: '1')
      expect(cookies[:remember_token].blank?).to(eq(false))
    end

    it "doesn't create a remember token when the remember me box isn't selected" do
      # login to set cookie
      log_in_user(user, remember_me: '1')

      # login again and make sure the cookie is deleted
      log_in_user(user, remember_me: '0')

      expect(cookies[:remember_token].blank?).to(eq(true))
    end
  end
end
