require 'test_helper'

class DirectionControllerTest < ActionController::TestCase
  test "should get redirect" do
    get :redirect
    assert_response :success
  end

  test "should get demo" do
    get :demo
    assert_response :success
  end

end
