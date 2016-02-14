require 'test_helper'

class ResearcherRankingsControllerTest < ActionController::TestCase
  setup do
    @researcher_ranking = researcher_rankings(:one)
    @search = searches(:one)
    @researcher = researchers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:researcher_rankings)
  end

  test "should get new" do
    get :new, search_id: @search.search_id, researcher_id: @researcher.id
    assert_response :success
  end

  test "should create researcher_ranking" do
    assert_difference('ResearcherRanking.count') do
      post :create, researcher_ranking: { researcher_id: @researcher_ranking.researcher_id, result_8: @researcher_ranking.result_8, result_5: @researcher_ranking.result_5, result_4: @researcher_ranking.result_4, result_9: @researcher_ranking.result_9, result_1: @researcher_ranking.result_1, result_7: @researcher_ranking.result_7, result_6: @researcher_ranking.result_6, result_10: @researcher_ranking.result_10, result_3: @researcher_ranking.result_3, result_2: @researcher_ranking.result_2, search_id: @researcher_ranking.search_id }
    end

    # the default test here assumed we would always direct users
    # to show the created user, but we intend to either prompt
    # the user with a question or a survey completed page
    #assert_redirected_to researcher_ranking_path(assigns(:researcher_ranking))
  end

  test "should show researcher_ranking" do
    get :show, id: @researcher_ranking.researcher_id
    assert_response :success
  end

end
