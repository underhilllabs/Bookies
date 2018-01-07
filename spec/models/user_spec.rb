require 'rails_helper'

describe User do
  let(:user) { User.new }
  describe "validation" do

    xit "fails without an email" do
      user.username = "test"
      user.email = nil
      expect(user).to_not be_valid
    end

    it "fails without a username" do
      user.username = nil
      user.email = "test@test.com"
      expect(user).to_not be_valid
    end

    it "fails wihout unique email" do
      user2 = User.new
      user2.email = "test@test.com"
      user.email = "test@test.com"
      expect(user).to_not be_valid
    end
    it "fails wih invalid email" do
      user.email = "test@ucdenver"
      user.username = "tester"
      expect(user).to_not be_valid
    end
    xit "succeeds wih valid email" do
      user.email = "test.user@ucdenver.edu"
      user.username = "tester"
      user.password_digest="89niu8nu8yhy9um08u8b8umu8uuex544deed"
      expect(user).to be_valid
    end
  end
end
