require 'rails_helper'

describe Bookmark do
  let(:bookmark) { Bookmark.new }
  # let(:user) { User.new }
  describe "validation" do

    it "fails without a URL" do
      bookmark.title = "test"
      bookmark.url = nil
      expect(bookmark).to_not be_valid
    end

    it "fails without a title" do
      bookmark.title = nil
      bookmark.url = "http://github.com"
      expect(bookmark).to_not be_valid
    end

    it "fails without a user" do
      bookmark.title = "test"
      bookmark.url =  "http://github.com"
      bookmark.user = nil
      expect(bookmark).to_not be_valid
    end

    it "saves hashed_url when saved" do
      bookmark.title = "test"
      bookmark.url =  "http://github.com"
      bookmark.user = nil
      expect(bookmark).to_not be_valid
    end
  end
end
