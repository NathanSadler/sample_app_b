require 'rails_helper'
require 'pry'

RSpec.describe User, type: :model do
  #pending "add some examples to (or delete) #{__FILE__}"
  let(:user) {User.new(name: "Test user", email: "user@example.com")}

  it("is initially valid") do
    expect(user.valid?).to(eq(true))
  end

  it("should have an email present") do
    user.name = "    "
    binding.pry
    expect(user.valid?).to(eq(false))
  end
end
