require 'rails_helper'

RSpec.describe Micropost, type: :model do
  fixtures :users
  fixtures :microposts
  let(:user) {users(:michael)}

  let(:micropost) {user.microposts.build(content: 'Lorem Ipsum')}

  context('validations') do
    it('should succeed when given content and a user id') do
      expect(micropost.valid?).to(be(true))
    end

    it('should fail when not given a user id') do
      micropost.user_id = nil
      expect(micropost.valid?).to(be(false))
    end

    it('should fail when content is not present') do
      micropost.content = "   "
      expect(micropost.valid?).to(be(false))
    end

    it('should fail when the content is more than 140 characters') do
      micropost.content = "a" * 141
      expect(micropost.valid?).to(be(false))
    end
  end

  it('should be ordered with the first being the most recent') do
    expect(microposts(:most_recent)).to(eq(Micropost.first))
  end

end
