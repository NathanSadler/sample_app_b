require 'rails_helper'

RSpec.describe 'relationships controller', type: :system do
  fixtures :relationships

  describe('#create') do
    it('should require a logged-in user') do
      expect {post relationships_path}.to_not change {Relationship.count}
      assert_redirected_to login_url
    end
  end

  describe('#destroy') do
    it('requires a logged-in user') do
      expect {delete relationship_path(relationships(:one))}.to_not change {Relationship.count}
      assert_redirected_to login_url
    end
  end
end
