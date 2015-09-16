require 'test_helper'

class GameControllerTest < ActionController::TestCase
  test "should get home" do
    get :home
    assert_response :success
  end

  test "should get settings" do
    get :settings
    assert_response :success
  end

  test "should get quiz" do
    get :quiz
    assert_response :success
  end

  test "should get result" do
    get :result
    assert_response :success
  end

end
