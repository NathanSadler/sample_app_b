require 'rails_helper'

RSpec.describe "User", type: :system do
  fixtures :users
  let(:user) {users(:michael)}
  let(:session) {Capybara::Session.new(:rack_test, Rails.application)}

  describe("user trying to update a user") do
    it("keeps the user on the update user page if their update is unsuccessful") do
      session.visit(edit_user_path(user))
      
    end
  end
end