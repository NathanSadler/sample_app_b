require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  fixtures :users
  let(:mail_from) { "nathansadler3@gmail.com" }
  let!(:user) {users(:michael)}

  before(:each) do
    user.activation_token = User.new_token
  end
  
  describe "account_activation" do
    let(:mail) { UserMailer.account_activation(user) }

    it "renders the headers" do
      expect(mail.subject).to eq("Account activation")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq([mail_from])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end

    it "has the user's name encoded" do
      expect(mail.body.encoded).to(match(user.name))
    end

    it "has the user's activation token encoded" do
      expect(mail.body.encoded).to(match(user.activation_token))
    end

    it "has the user's email encoded" do
      expect(mail.body.encoded).to(match(CGI.escape(user.email)))
    end
    
  end

  describe "password_reset" do
    let(:mail) { UserMailer.password_reset(user) }

    it "renders the headers" do
      expect(mail.subject).to eq("Password Reset")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq([mail_from])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
