require 'test_helper'

class ResearcherRankingsControllerTest < ActionController::TestCase
  setup do
    @researcher_ranking = researcher_rankings(:one)
    @search_id = 1
    @researcher_id = 1
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
      post :create, researcher_ranking: { researcher_id: @researcher_ranking.researcher_id, result_8: @researcher_ranking.result_8, result_5: @researcher_ranking.result_5, result_4: @researcher_ranking.result_4, result_9: @researcher_ranking.result_9, result_1: @researcher_ranking.result_1, result_7: @researcher_ranking.result_7, result_6: @researcher_ranking.result_6, result_10: @researcher_ranking.result_10, result_3: @researcher_ranking.result_3, result_2: @researcher_ranking.result_2, search_id: @researcher_ranking.search_id }
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
    patch :update, id: @researcher_ranking, researcher_ranking: { researcher_id: @researcher_ranking.researcher_id, result_8: @researcher_ranking.result_8, result_5: @researcher_ranking.result_5, result_4: @researcher_ranking.result_4, result_9: @researcher_ranking.result_9, result_1: @researcher_ranking.result_1, result_7: @researcher_ranking.result_7, result_6: @researcher_ranking.result_6, result_10: @researcher_ranking.result_10, result_3: @researcher_ranking.result_3, result_2: @researcher_ranking.result_2, search_id: @researcher_ranking.search_id }
    assert_redirected_to researcher_ranking_path(assigns(:researcher_ranking))
  end

  test "should destroy researcher_ranking" do
    assert_difference('ResearcherRanking.count', -1) do
      delete :destroy, id: @researcher_ranking
    end

    assert_redirected_to researcher_rankings_path
  end
end
