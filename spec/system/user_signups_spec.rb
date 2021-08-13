require 'rails_helper'
require_relative '../helpers/users_helper_spec'

RSpec.describe 'UsersSignups', type: :system do

  let(:session) {Capybara::Session.new(:rack_test, Rails.application)}

  before(:each) do
    ActionMailer::Base.deliveries.clear
  end

  context 'signing up with invalid information' do
    def sign_up_with_session(current_session)
      sign_up(
        session: current_session,
        name: '',
        email: 'user@invalid', 
        password: 'foo', 
        password_confirmation: 'bar'
      )
    end

    before(:each) do
      sign_up_with_session(session)
    end

    it "doesn't create a new user" do
      expect {sign_up_with_session(session)}.to_not change { User.count }
    end

    it 'displays a div listing the errors' do
      error_explanations = session.all('div#error_explanation')
      expect(error_explanations.length).to be > 0
      expect(error_explanations[0].text.empty?).to(be(false))
    end

    it "creates divs with class 'field_with_errors'" do
      expect(session.all('div.field_with_errors').length).to be > 0
    end
  end
end

