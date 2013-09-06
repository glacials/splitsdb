require 'test_helper'

class GameControllerTest < ActionController::TestCase
  test "should get name:string" do
    get :name:string
    assert_response :success
  end

  test "should get game_controller:references" do
    get :game_controller:references
    assert_response :success
  end

end
