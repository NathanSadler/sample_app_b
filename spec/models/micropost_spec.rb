require 'rails_helper'

RSpec.describe Micropost, type: :model do
  fixtures :users
  let(:user) {users(:michael)}

  let(:micropost) {Micropost.new(content: 'Lorem ipsum', user_id: user.id)}

  context('validations') do
    it('should succeed when given content and a user id') do
      expect(micropost.valid?).to(be(true))
    end

    it('should fail when not given a user id') do
      micropost.user_id = nil
      binding.pry
      expect(micropost.valid?).to(be(false))
    end
  end
end
