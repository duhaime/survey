require 'test_helper'

class ResearchersControllerTest < ActionController::TestCase
  setup do
    @researcher = researchers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:researchers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create researcher" do
    assert_difference('Researcher.count') do
      post :create, researcher: { email: @researcher.email, name: @researcher.name, position: @researcher.position, search_group_id: @researcher.search_group_id, university: @researcher.university }
    end

    # the default test assumed we would show the user
    # the profile they just created, but we will redirect to 
    # their first question
    #assert_redirected_to researcher_path(assigns(:researcher))
  end

  test "should show researcher" do
    get :show, id: @researcher
    assert_response :success
  end

end
