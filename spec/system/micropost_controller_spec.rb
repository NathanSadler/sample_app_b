require 'rails_helper'
require_relative '../helpers/users_helper_spec'

RSpec.describe "Micropost controller", type: :request do
  fixtures :microposts

  let(:micropost) {microposts(:orange)}

  context 'create' do
    it('should redirect when not logged in') do
      expect {post microposts_path, params: { micropost: { content: "Lorem ipsum" } }}.not_to change {Micropost.count}
      assert_redirected_to login_url
    end
  end

  context 'destroy' do
    it ('should redirect when not logged in') do
      expect {delete micropost_path(micropost)}.not_to change {Micropost.count}
      assert_redirected_to login_url
    end
  end
end