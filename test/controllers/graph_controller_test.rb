require 'test_helper'

class GraphControllerTest < ActionController::TestCase
  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get data" do
    get :data, format: :json
    assert_response :success
  end

end
