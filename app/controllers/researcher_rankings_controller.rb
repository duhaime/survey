class ResearcherRankingsController < ApplicationController
  before_action :set_researcher_ranking, only: [:show, :edit, :update, :destroy]

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

    # Set instance variables for search, researcher_id, and search_results
    @search_id = params[:search_id]
    @researcher_id = params[:researcher_id]
    @search_results = SearchResult.where(search_id: @search_id)
    @search_phrase = retrieve_search_phrase(@search_id)
  end

  # GET /researcher_rankings/1/edit
  def edit
  end

  # POST /researcher_rankings
  # POST /researcher_rankings.json
  def create
    @researcher_ranking = ResearcherRanking.new(researcher_ranking_params)
    @researcher_id = researcher_ranking_params["researcher_id"]
    @search_id = researcher_ranking_params["search_id"]

    respond_to do |format|
      if @researcher_ranking.save

        # on successful submission of form, check to see if the
        # researcher has responded to all queries in their
        # search_group_id. If so, send the to a congratulations page
        if survey_completed(@researcher_id, @search_id)
          format.html { redirect_to :controller => 'survey_completed', :action => 'show' }
        else
          format.html { redirect_to new_researcher_ranking_path(:researcher_id => @researcher_id, :search_id => find_next_search_result(@researcher_id, @search_id)), action: show, notice: 'Success! Your information has been saved.', status: 301 }
          format.json { render action: 'show', status: :created, location: @researcher_ranking }
        end

      else
        format.html { render action: 'new' }
        format.json { render json: @researcher_ranking.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /researcher_rankings/1
  # PATCH/PUT /researcher_rankings/1.json
  def update
    respond_to do |format|
      if @researcher_ranking.update(researcher_ranking_params)
        format.html { redirect_to @researcher_ranking, notice: 'Researcher ranking was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @researcher_ranking.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /researcher_rankings/1
  # DELETE /researcher_rankings/1.json
  def destroy
    @researcher_ranking.destroy
    respond_to do |format|
      format.html { redirect_to researcher_rankings_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_researcher_ranking
      @researcher_ranking = ResearcherRanking.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def researcher_ranking_params
      params.require(:researcher_ranking).permit(:search_id, :researcher_id, :result_1, :result_2, :result_3, :result_4, :result_5, :result_6, :result_7, :result_8, :result_9, :result_10)
    end

    def retrieve_search_phrase(search_id_instance)
      search = Search.where(search_id: search_id_instance)
      
      # nb: where queries always return an array, and
      # each search object has a unique id, so call first
      return search.first.search_phrase 
    end

    def find_next_search_result(researcher_id_instance, search_id_instance)
      puts researcher_id_instance
      researcher_search_group_id = Researcher.where(id: researcher_id_instance)[0].search_group_id

      # retrieve all searches for the given search_group_id
      relevant_searches = SearchGroup.where(search_group_id: researcher_search_group_id)

      # initialize a variable that represents the index
      # position of the search we need to return
      next_search_index = 0

      # find the index position of the current search id 
      # within the relevant searches, and use this index
      # to determine the next search to serve up. 

      # NB: If the researcher has cycled through the 
      # searches they need to answer, we should return
      # a special flag that indicates the user is done
      relevant_searches.each_with_index do |rs, rs_index|
        if rs.search_id.to_i == search_id_instance.to_i
          return relevant_searches[rs_index+1].search_id
        end
      end
      return relevant_searches[next_search_index].search_id
    end

    def survey_completed(researcher_id_instance, search_id_instance)
      # to determine if researcher is done, retrieve their 
      # search group id, then retrieve 
      researcher_search_group_id = Researcher.where(id: researcher_id_instance)[0].search_group_id
      relevant_searches = SearchGroup.where(search_group_id: researcher_search_group_id)
      last_relevant_search_id = relevant_searches.last.search_id
      
      if last_relevant_search_id.to_i == search_id_instance.to_i
        return true
      else
        return false
      end
    end

end
