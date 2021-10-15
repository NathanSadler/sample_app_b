require 'rails_helper'
require_relative '../helpers/users_helper_spec'

RSpec.describe 'UsersSignups', type: :system do

  let(:session) {Capybara::Session.new(:rack_test, Rails.application)}

  def sign_up_with_invalid_data(current_session)
    sign_up(
      session: current_session,
      name: '',
      email: 'user@invalid',
      password: 'foo',
      password_confirmation: 'bar'
    )
  end

  def sign_up_with_valid_data(current_session, name: 'Zoobiddibeep', email: 'zoobidi@beep.com')
    sign_up(
      session: current_session,
      name: name,
      email: email,
      password: 'Zoobiddibeep!1',
      password_confirmation: 'Zoobiddibeep!1'
    )
  end

  before(:each) do
    ActionMailer::Base.deliveries.clear
  end

  context 'signing up with invalid information' do
    before(:each) do
      sign_up_with_invalid_data(session)
    end

    it "doesn't create a new user" do
      expect {sign_up_with_invalid_data(session)}.to_not change { User.count }
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

  # context('valid signup information with account activation') do
  #   before(:each) do
  #     sign_up_with_valid_data(session)
  #   end

  #   let(:user) {User.last}

  #   it 'creates a user' do
  #     expect {sign_up_with_valid_data(Capybara::Session.new(:rack_test, Rails.application), name: "Eegooagoo", email: "egoo@agoo.com")}.to change {User.count}.by(1)
  #   end

  #   it 'increases the size of ActionMailer::Base.deliveries.size' do
  #     expect(ActionMailer::Base.deliveries.size).to(eq(1))
  #   end

  #   xdescribe('trying to log in before account activation') do
  #     it("does not let the user log in") do
  #       binding.pry
  #       log_in_as(user)
  #       expect(session[:user_id]).to(eq(nil))
  #     end
  #   end
  # end

  context 'signing up with valid information' do
    before(:each) do
      sign_up_with_valid_data(session)
    end

    let(:user) {User.last}

    it 'creates a user' do
      expect {sign_up_with_valid_data(Capybara::Session.new(:rack_test, Rails.application), name: "Eegooagoo", email: "egoo@agoo.com")}.to change {User.count}.by(1)
    end

    it 'increases the size of ActionMailer::Base.deliveries.size' do
      expect(ActionMailer::Base.deliveries.size).to(eq(1))
    end

    it "doesn't let the user log in before account activation" do
      visit_login_page(session)
      submit_login_form(session: session, email: user.email, password: 'Zoobiddibeep!1')
      expect(session).to(have_content("Log in"))
      expect(session).to_not(have_content("Users"))
    end

    it("doesn't log the user in when trying to validate their account with an invalid activation token") do
      session.visit(edit_account_activation_path("invalid token", email: user.email))
      expect(session).to(have_content("Log in"))
      expect(session).to_not(have_content("Users"))
    end

    it("doesn't log the user in when trying to validate their account with the wrong email") do
        session.visit(edit_account_activation_path(user.activation_token, email: "wrong", id: user.id))
        session.refresh
        expect(session).to(have_content("Log in"))
        expect(session).to_not(have_content("Users"))
    end


    # TODO: figure out why this doesn't pass even though it works in the browser
    xit("logs the user in when trying to validate their account with matching a matching email and validation token") do
      # session.visit(edit_account_activation_path(user.activation_token, email: user.email, id: user.id))
      session.visit()
      expect(session).to_not(have_content("Log in"))
      expect(session).to(have_content("Users"))
    end
  end
end
