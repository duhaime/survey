require 'test_helper'

class ResearcherRankingsControllerTest < ActionController::TestCase
  setup do
    @researcher_ranking = researcher_rankings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:researcher_rankings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create researcher_ranking" do
    assert_difference('ResearcherRanking.count') do
      post :create, researcher_ranking: { researcher_id: @researcher_ranking.researcher_id, result_eight: @researcher_ranking.result_eight, result_five: @researcher_ranking.result_five, result_four: @researcher_ranking.result_four, result_nine: @researcher_ranking.result_nine, result_one: @researcher_ranking.result_one, result_seven: @researcher_ranking.result_seven, result_six: @researcher_ranking.result_six, result_ten: @researcher_ranking.result_ten, result_three: @researcher_ranking.result_three, result_two: @researcher_ranking.result_two, search_id: @researcher_ranking.search_id }
    end

    assert_redirected_to researcher_ranking_path(assigns(:researcher_ranking))
  end

  test "should show researcher_ranking" do
    get :show, id: @researcher_ranking
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @researcher_ranking
    assert_response :success
  end

  test "should update researcher_ranking" do
    patch :update, id: @researcher_ranking, researcher_ranking: { researcher_id: @researcher_ranking.researcher_id, result_eight: @researcher_ranking.result_eight, result_five: @researcher_ranking.result_five, result_four: @researcher_ranking.result_four, result_nine: @researcher_ranking.result_nine, result_one: @researcher_ranking.result_one, result_seven: @researcher_ranking.result_seven, result_six: @researcher_ranking.result_six, result_ten: @researcher_ranking.result_ten, result_three: @researcher_ranking.result_three, result_two: @researcher_ranking.result_two, search_id: @researcher_ranking.search_id }
    assert_redirected_to researcher_ranking_path(assigns(:researcher_ranking))
  end

  test "should destroy researcher_ranking" do
    assert_difference('ResearcherRanking.count', -1) do
      delete :destroy, id: @researcher_ranking
    end

    assert_redirected_to researcher_rankings_path
  end
end
