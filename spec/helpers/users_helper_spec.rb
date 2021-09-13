require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the UsersHelper. For example:
#
# describe UsersHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end

def is_logged_in?
  !session[:user_id].nil?
end

# def log_in_as(user)
#   session[:user_id] = user.id
# end

def log_in_as(user, password: 'password', remember_me: '1')
  post login_path, params: { session: { email: user.email,
                                        password: password,
                                        remember_me: remember_me } }
end

# RSpec.describe UsersHelper, type: :helper do
#   pending "add some examples to (or delete) #{__FILE__}"
# end
