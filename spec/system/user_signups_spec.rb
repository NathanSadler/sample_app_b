require 'rails_helper'
require_relative '../helpers/users_helper_spec'

RSpec.describe "UsersSignups", type: :system do
  before(:each) do
    ActionMailer::Base.deliveries.clear
  end

  let(:session) {Capybara::Session.new(:rack_test, Rails.application)}

  describe("signing up with invalid information") do

    it("doesn't create a new user") do
      expect { sign_up(
        session: session, 
        name: "", 
        email: "user@invalid", 
        password: "foo", 
        password_confirmation: "bar")
     }.to change {User.count}.by(0)
    end

    

  end
end