require 'test_helper'

class TagControllerTest < ActionController::TestCase
  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get rename" do
    get :rename
    assert_response :success
  end

  test "should get delete" do
    get :delete
    assert_response :success
  end

  test "should get search" do
    get :search
    assert_response :success
  end

end
