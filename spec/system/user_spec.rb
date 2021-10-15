require 'rails_helper'

RSpec.describe "User", type: :system do
  fixtures :users
  let(:user) {users(:michael)}
  let(:user2) {users(:archer)}
  let(:session) {Capybara::Session.new(:rack_test, Rails.application)}
  let(:session2) {Capybara::Session.new(:rack_test, Rails.application)}

  before(:each) do
    session.visit(login_path)
    submit_login_form(session: session, email: user.email, password: "password")
  end

  describe('following and unfollowing') do
    it("should redirect following when not logged in") do
      session2.visit(following_user_path(user))
      expect(session2.current_path).to(eq('/login'))
    end

    it("should redirect followers when not logged in") do
      session2.visit(followers_user_path(user))
      expect(session2.current_path).to(eq('/login'))
    end
  end

  describe("user trying to update a user") do
    before(:each) do
      session.visit(edit_user_path(user))
    end

    it("keeps the user on the update user page if their update is unsuccessful") do
      submit_user_form(session: session, name: " ", email:"foo@invalid", password:"foo", password_confirmation: "bar",
        button_text: "Save Changes")
      expect(session).to(have_content("Password is too short"))
    end

    it("should redirect update when not logged in") do
      session.find('.dropdown>ul>li>a', text: "Log out").click
      expect(session.current_path).to(eq('/'))
      patch user_path(user), params: {user: {name: user.name, email: user.email}}
      expect(flash.empty?).to(be(false))
    end

    it("doesn't let the user update a user's information if they aren't logged in") do
      session2.visit(edit_user_path(user))
      expect(session2.has_content?("Please log in.")).to(be(true))
    end

    it("takes the user to the edit page if they log in after being directed to the login page because they weren't signed in") do
      session2.visit(edit_user_path(user2))
      submit_login_form(session: session2, email: user2.email, password: 'password')
      expect(session2.current_path).to(eq("/users/#{user2.id}/edit"))
    end

    describe("a logged in user trying to update a different user") do
      before(:each) do
        session2.visit(login_path)
        submit_login_form(session: session2, email: "duchess@example.gov", password: "password")
        session2.visit(edit_user_path(user))
      end

      it("returns the logged-in user to the homepage") do
        expect(session2.current_path).to(eq("/"))
      end

      it("doesn't display a flash") do
        expect(session2).to_not(have_content("Please log in."))
      end
    end

    describe("with valid information") do
      before(:each) do
        submit_user_form(session: session, name: "Foo Bar", email: "foo@bar.com", password: "",
          button_text: "Save Changes")
      end

      it("moves the user to their profile page and updates their information") do
        expect(session.has_no_button?("Save Changes")).to(be(true))
        expect(session.current_path).to(eq("/users/#{user.id}"))
      end

      it("updates their information") do
        expect(User.find(user.id).name).to(eq("Foo Bar"))
        expect(User.find(user.id).email).to(eq("foo@bar.com"))
      end
    end
  end

  describe("user actions") do
    describe("destroy") do
      it("lets admins delete users") do
        user_count = User.count
        session.visit(users_path)
        session.find("ul.users>li:last-child>a:last-child").click
        expect(User.count).to(eq(user_count - 1))
      end

      it("doesn't display delete links for non-admins") do
        user.toggle!(:admin)
        session.visit(users_path)
        expect(session).to_not(have_content("delete"))
      end

      it("should redirect users when not logged in as an admin") do
        user_count = User.count
        delete user_path(2)
        expect(User.count).to(eq(user_count))
      end
    end

    describe("index") do
      it("prevents non-logged in users from seeing it") do
        session2.visit(users_path)
        expect(session2.current_path).to(eq("/login"))
      end

      it("has pagination") do
        session.visit(users_path)
        expect(session.all("ul.pagination").length).to(eq(2))
      end
    end
  end

end
