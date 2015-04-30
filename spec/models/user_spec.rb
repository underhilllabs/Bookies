require 'rails_helper'

describe User do
  let(:user) { User.new }
  describe "validation" do

    it "fails without an email" do
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
      user2 = User.new email: "test@test.com", username: "test"
      user.email = "test@test.com"
      expect(user).to_not be_valid
    end
  end
end
