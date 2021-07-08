require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe "GET /new" do
    it "should get new" do
      get login_path
      assert_response :success
    end
  end

end
