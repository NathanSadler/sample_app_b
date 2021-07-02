require 'rails_helper'


RSpec.describe "StaticPages", type: :request do
  let (:base_title) {"Ruby on Rails Tutorial Sample App"}

  describe "GET /home" do
    it "returns http success" do
      get "/static_pages/home"
      expect(response).to have_http_status(:success)
      expect(response.body.include?("<html><head><title>#{base_title}")).to(eq(true))
    end
  end

  describe "GET /help" do
    it "returns http success" do
      get "/static_pages/help"
      expect(response).to have_http_status(:success)
      expect(response.body.include?("<html><head><title>Help | #{base_title}")).to(eq(true))
    end
  end

  describe "GET /about" do
    it("should get about") do
      get "/static_pages/about"
      expect(response).to(have_http_status(:success))
      expect(response.body.include?("<html><head><title>About | #{base_title}")).to(eq(true))
    end
  end

  describe "GET /" do
    it("returns root") do
      get "/"
      expect(response).to have_http_status(:success)
      expect(response.body.include?("<html><head><title>#{base_title}")).to(eq(true))
    end
  end

  describe "GET /" do
    it("returns the contact page") do
      get "/static_pages/contact_url"
      expect(response).to(have_http_status(:success))
      expect(response.body.include?("<html><head><title>Contact | #{base_title}")).to(eq(true))
    end
  end

end
