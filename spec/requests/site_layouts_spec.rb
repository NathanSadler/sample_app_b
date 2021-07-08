require 'rails_helper'

RSpec.describe "SiteLayouts", type: :request do
  describe "GET /site_layouts" do
    it "layout links" do
      get root_path
      expect(response.body.include?("<title>Ruby on Rails Tutorial Sample App"))
      assert_select "a[href=?]", root_path, count: 3
      [help_path, about_path, contact_path].each do |path|
        assert_select "a[href=?]", path
      end
    end
  end
end
