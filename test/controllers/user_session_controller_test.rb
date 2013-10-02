require 'test_helper'

class UserSessionControllerTest < ActionController::TestCase
  test "should get email:string" do
    get :email:string
    assert_response :success
  end

  test "should get password:string" do
    get :password:string
    assert_response :success
  end

end
