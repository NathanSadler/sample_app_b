require 'rails_helper'
require_relative '../helpers/users_helper_spec'
include ApplicationHelper

RSpec.describe "following", type: :system do
  fixtures :users
  fixtures :relationships

  let(:user) {users(:michael)}
  let(:other) {users(:archer)}

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

  describe("following a user without Ajax") do
    it("should increase the followed user's followers count by 1") do
      expect {post relationships_path, params: {followed_id: other.id}}.to change {user.following.count}.by(1)
    end
  end

  describe("following a user with Ajax") do
    it("should increase the followed user's followers count by 1") do
      expect {post relationships_path, xhr: true, params: {followed_id: other.id}}.to change {user.following.count}.by(1)
    end
  end

  describe("unfollowing a user without ajax") do
    it("should decrease the unfollowed user's follower count by one") do
      user.follow(other)
      relationship = user.active_relationships.find_by(followed_id: other.id)
      expect {delete relationship_path(relationship)}.to change{user.following.count}.by(-1)
    end
  end

  describe("unfollowing a user with ajax") do
    it("should decrease the unfollowed user's follower count by one") do
      user.follow(other)
      relationship = user.active_relationships.find_by(followed_id: other.id)
      expect {delete relationship_path(relationship), xhr: true}.to change{user.following.count}.by(-1)
    end
  end
end
