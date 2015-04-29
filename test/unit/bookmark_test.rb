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
end
