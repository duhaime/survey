class ResearcherRankingsController < ApplicationController
  before_action :set_researcher_ranking, only: [:show]

  # GET /researcher_rankings
  # GET /researcher_rankings.json
  def index
    @researcher_rankings = ResearcherRanking.all
  end

  # GET /researcher_rankings/1
  # GET /researcher_rankings/1.json
  def show
  end


  # GET /researcher_rankings/new
  def new
    @researcher_ranking = ResearcherRanking.new

    # Set instance variables for the researcher and their current question number
    @researcher_email = params[:researcher_email] 
    @search_number = params[:search_number]

    # retrieve the search group object for the current search
    @current_search_metadata = find_current_search_metadata(@researcher_email, @search_number)

    # retrieve the search for this search
    @current_search = find_current_search(@current_search_metadata)

    # pass the search phrase to the client for display
    @search_phrase = @current_search.search_phrase

    # retrieve the search results for the current search
    @search_results = find_current_search_results(@current_search_metadata)

    # also pass id values for the current search, and platform
    @search_id = @current_search.search_id
    @platform_id = @current_search.platform_id
  end


  # POST /researcher_rankings
  # POST /researcher_rankings.json
  def create
    @researcher_ranking = ResearcherRanking.new(researcher_ranking_params)
    
    # retrieve id values from the autofilled form params
    @researcher_email = researcher_ranking_params["researcher_email"]
    @search_id = researcher_ranking_params["search_id"]
    @platform_id = researcher_ranking_params["platform_id"]
    @search_number = researcher_ranking_params["search_number"]

    respond_to do |format|
      if @researcher_ranking.save
        # on successful submission of form, check to see if the
        # researcher has responded to all queries in their
        # search_group_id. If so, send the user to a congratulations page
        # nb: add 1 to the current search number because we start counting
        # searches from 0, while a 1-question array has length 1
        if survey_completed(@researcher_email, @search_number)
          format.html { redirect_to :controller => 'survey_completed', :action => 'show' }
        
        else
          format.html { 
            redirect_to new_researcher_ranking_path(
              :researcher_email => @researcher_email,
              :search_number => @search_number.to_i + 1
            ),
             action: show, 
             notice: 'Success! Your information has been saved.', 
             status: 301 }
          

          format.json { render action: 'show', status: :created, location: @researcher_ranking }
        end

      else
        format.html { render action: 'new' }
        format.json { render json: @researcher_ranking.errors, status: :unprocessable_entity }
      end
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_researcher_ranking
      @researcher_ranking = ResearcherRanking.find(params[:id])
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def researcher_ranking_params
      params.require(:researcher_ranking).permit(:search_id, :platform_id, :researcher_email, :search_number, :result_1, :result_2, :result_3, :result_4, :result_5, :result_6, :result_7, :result_8, :result_9, :result_10)
    end


    def find_current_search_metadata(researcher_email, search_number)
      """
      return a SearchGroup object that describes the current search
      assigned to the researcher. This SearchGroup object will
      have the search_id and platform_id properties required so that
      we can uniquely identify the relevant Search object
      """

      researcher_search_group_id = Researcher.find_by(email: researcher_email).search_group_id
      # sort the searches by their search id so that researchers will evaluate
      # all of the queries for "donkey kong" before evaluating all of the
      # results on "mario kart"
      searches_assigned_to_researcher = SearchGroup.where(search_group_id: researcher_search_group_id).order(:search_phrase)
      return searches_assigned_to_researcher[search_number.to_i]
    end


    def find_current_search(current_search_metadata)
      """
      read in a SearchGroup object that contains keys for the 
      search_id and platform_id that together describe the
      search the current researcher should evaluate
      """

      # find the current search id and platform 
      current_search_id = current_search_metadata.search_id
      current_search_platform_id = current_search_metadata.platform_id

      # find all searches with the current search id
      candidate_searches = Search.where(search_id: current_search_id)

      # of those searches, return the one with the given platform id
      return candidate_searches.where(platform_id: current_search_platform_id).take
    end


    def find_current_search_results(current_search_metadata)
      """
      read in a SearchGroup object that contains keys for the 
      search_id and platform_id that together describe the
      search for which this method will return the search results
      """

      # find the current search id and platform 
      current_search_id = current_search_metadata.search_id
      current_search_platform_id = current_search_metadata.platform_id

      # return all search results for this search
      candidate_search_results = SearchResult.where(search_id: current_search_id)

      return candidate_search_results.where(platform_id: current_search_platform_id)
    end


    def survey_completed(researcher_email, search_number)
      """
      Read in the current researcher's email and the search number they 
      just completed, and return true if they're done with the survey and 
      false if they have more questions to answer
      """ 
      # nb: add 1 to the current search value to determine the number
      # of completed searches, as we start the researcher on search number
      # 0, while a single member list has length 1
      completed_searches = search_number.to_i + 1
      researcher_search_group_id = Researcher.find_by(email: researcher_email).search_group_id
      n_searches_assigned_to_researcher = SearchGroup.where(search_group_id: researcher_search_group_id).length
      if completed_searches == n_searches_assigned_to_researcher
        return true
      else
        return false
      end
    end

end
