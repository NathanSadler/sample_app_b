require 'rails_helper'
require 'pry'

RSpec.describe User, type: :model do
  #pending "add some examples to (or delete) #{__FILE__}"
  let(:user) {User.new(name: "Test user", email: "user@example.com",
    password: "foobar", password_confirmation: "foobar")}

  it("is initially valid") do
    expect(user.valid?).to(eq(true))
  end

  it("should have an name present") do
    user.name = "     "
    expect(user.valid?).to(eq(false))
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
