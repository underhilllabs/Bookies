require 'test_helper'

class BookmarkTest < ActiveSupport::TestCase
  test "validates bookmarked owned by user" do
    @bookmark1 = bookmarks(:one)
    @bookmark1.user = nil
    assert_not @bookmark1.valid?
  end

  test "validates url" do
    @bookmark1 = bookmarks(:one)
    @bookmark1.url = ''
    assert_not @bookmark1.valid?
  end

  test "validates title" do
    @bookmark1 = bookmarks(:one)
    @bookmark1.title = ''
    assert_not @bookmark1.valid?
  end

  test "saves hashed_url when saved" do
    @bookmark1 = bookmarks(:one)
    @bookmark1.save
    #assert @bookmark1.hashed_url.present?
    assert_equal( @bookmark1.hashed_url, Digest::MD5.hexdigest(@bookmark1.url) ) 
  end
end
