require 'rails_helper'

RSpec.describe "Relationships", type: :request do
  describe "creating a relationship" do
    it("should require a user to be logged in") do
      assert_no_difference 'Relationship.count' do
        post relationships_path
      end
      assert_redirected_to login_url
    end
  end
end
