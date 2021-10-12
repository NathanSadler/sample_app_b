require 'rails_helper'
require_relative '../helpers/users_helper_spec'
include ApplicationHelper

RSpec.describe "following", type: :system do
  fixtures :users
  fixtures :relationships

  let(:user) {users(:michael)}

  before(:each) do
    log_in_as(user)
  end

  def document_root_element()
    Nokogiri::HTML::Document.parse(response.body)
  end

  it("following page") do
    get following_user_path(user)
    assert !user.following.empty?
    assert_match user.following.count.to_s, response.body
    user.following.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end

  it("followers page") do
    get followers_user_path(user)
    assert !user.followers.empty?
    assert_match user.followers.count.to_s, response.body
    user.followers.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end
end
