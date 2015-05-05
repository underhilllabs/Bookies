require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "validates username" do
    @user1 = users(:bossy)
    @user1.username = ''
    assert_not @user1.valid?
  end

  test "validates email presence" do
    @user1 = users(:bossy)
    @user1.email = nil
    assert_not @user1.valid?
  end

  test "validates email uniqueness" do
    @user1 = users(:bossy)
    @user2 = users(:seamus)
    @user1.email = @user2.email
    assert_not @user1.valid?
  end
end
