require 'rails_helper'
require_relative '../helpers/users_helper_spec'

RSpec.describe 'PasswordResets', type: :system do
  let(:user) {users(:michael)}
  let(:session) {Capybara::Session.new(:rack_test, Rails.application)}

  before(:each) do
    session.visit(new_password_reset_path)
  end

  context 'trying to reset a password using an invalid email' do
    
  end
end
