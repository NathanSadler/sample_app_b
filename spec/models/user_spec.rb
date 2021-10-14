require 'rails_helper'
require 'pry'

RSpec.describe User, type: :model do
  #pending "add some examples to (or delete) #{__FILE__}"
  let(:user) {User.new(name: "Test user", email: "user@example.com",
    password: "foobar", password_confirmation: "foobar")}

  fixtures :users

  let(:michael) {users(:michael)}
  let(:archer) {users(:archer)}
  let(:lana) {users(:lana)}

  it("is initially valid") do
    expect(user.valid?).to(eq(true))
  end

  describe('#follow') do
    before(:each) {michael.follow(archer)}

    it('lets a user follow another user') do
      expect(michael.following?(archer)).to(eq(true))
    end

    it("adds the following user to the followed's list of followers") do
      expect(archer.followers.include?(michael)).to(eq(true))
    end

    it('does not let a user follow themself') do
      michael.follow(michael)
      expect(michael.following?(michael)).to(eq(false))
    end
  end

  describe('#unfollow') do
    it('lets one user unfollow another') do
      michael.follow(archer)
      michael.unfollow(archer)
      expect(michael.following?(archer)).to(eq(false))
    end
  end

  describe('#feed') do
    it('contains of the posts of each user the user is following') do
      lana.microposts.each do |post_following|
        expect(michael.feed.include?(post_following)).to(eq(true))
      end
    end

    it("contains the user's own posts if they have followers") do
      michael.microposts.each do |post_self|
        expect(michael.feed.include?(post_self)).to(eq(true))
      end
    end

    it("contains the user's own posts if they don't have followers") do
      archer.microposts.each do |post_self|
        expect(archer.feed.include?(post_self)).to(eq(true))
      end
    end

    it("does not contain posts from users that the user doesn't follow") do
      archer.microposts.each do |post_unfollowed|
        expect(michael.feed.include?(post_unfollowed)).to(eq(false))
      end
    end
  end

  it("following/unfollowing users") do
    michael = users(:michael)
    archer = users(:archer)
    assert !michael.following?(archer)
    michael.follow(archer)
    assert michael.following?(archer)
    michael.unfollow(archer)
    assert !michael.following?(archer)
    # Users can't follow themselves.
    michael.follow(michael)
    assert !michael.following?(michael)
  end

  it("should have an name present") do
    user.name = "     "
    expect(user.valid?).to(eq(false))
  end

  it('should destroy associated microposts when destroyed') do
    user.save
    user.microposts.create!(content: 'Lorem ipsum')
    expect {user.destroy}.to change {Micropost.count}.by(-1)
  end

  it("should not have a name longer than 50 chars") do
    user.name = "A" * 51
    expect(user.valid?).to(eq(false))
  end

  it("should have an email present") do
    user.email = "  "
    expect(user.valid?).to(eq(false))
  end

  it("should not have an email longer than 255 chars") do
    user.email = ("a" * 244) + "@example.com"
    expect(user.valid?).to(eq(false))
  end

  it("accepts valid email addresses") do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                     first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      user.email = valid_address
      expect(user.valid?).to(eq(true))
    end
  end

  it("rejects invalid email addresses") do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      user.email = invalid_address
      expect(user.valid?).to(eq(false))
    end
  end

  it("should have unique email addresses") do
    duplicate_user = user.dup
    user.save
    expect(duplicate_user.valid?).to(eq(false))
  end

  describe('authenticated?') do
    it("should return false for a user with nil digest") do
      expect(user.authenticated?(:remember, '')).to(be(false))
    end
  end

  context('password') do
    it("should be present") do
      user.password = user.password_confirmation = " " * 6
      expect(user.valid?).to(eq(false))
    end

    it("should be at least 6 chars long") do
      user.password = user.password_confirmation = " " * 5
      expect(user.valid?).to(eq(false))
    end
  end
end
