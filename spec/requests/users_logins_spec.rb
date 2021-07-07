require 'rails_helper'

RSpec.describe "UsersLogins", type: :request do
  describe "GET /users_logins" do
    it "doesn't display a flash when the user moves to another page" do
      get login_path
      expect(request.path).to(eq('/login'))
      post login_path, params: {session: {email: "", password: ""}}
      expect(request.path).to(eq('/login'))
      expect(flash.empty?).to(eq(false))
      get root_path
      expect(flash.empty?).to(eq(true))
    end
  end
end
