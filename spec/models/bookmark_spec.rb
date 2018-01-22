require 'rails_helper'

describe Bookmark do
  let(:bookmark) { Bookmark.new }
  let(:user) { User.create(username: "Tester") }
  describe "validations" do

    it "fails without a URL" do
      bookmark.title = "test"
      bookmark.url = nil
      bookmark.user = user
      expect(bookmark).to_not be_valid
    end

    it "fails without a title" do
      bookmark.title = nil
      bookmark.url = "http://github.com"
      bookmark.user = user
      expect(bookmark).to_not be_valid
    end

    it "fails without a user" do
      bookmark.title = "test"
      bookmark.url =  "http://github.com"
      bookmark.user = nil
      expect(bookmark).to_not be_valid
    end

    it "saves bookmark with correct attrbutes" do
      bookmark.title = "test"
      bookmark.url =  "http://github.com"
      bookmark.user = user
      bookmark.save
      expect(bookmark).to be_valid
    end

  end
  describe "on save" do
    it "saves creates a url hash on save" do
      bookmark.title = "test"
      bookmark.url =  "http://github.com"
      bookmark.user = user
      bookmark.save
      expect(bookmark.hashed_url).to_not be_nil
    end
  end
end
