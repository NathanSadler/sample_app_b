require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the SessionsHelper. For example:
#
# describe SessionsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe SessionsHelper, type: :helper do
  fixtures :users
  let!(:user) {users(:michael)}

  before(:each) do
    # remember(user)
  end

  describe("current_user") do
    it("returns right user when session is nil") do
      remember(user)
      expect(user).to(eq(current_user))
      expect(is_logged_in?).to(eq(true))
    end

    it("returns nil when the user digest is wrong") do
      user.update_attribute(:remember_digest, User.digest(User.new_token))
      expect(current_user.nil?).to(be(true))
    end
  end
end
