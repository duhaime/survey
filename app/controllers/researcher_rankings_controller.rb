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
    
    # Setting the search id feld here allows the view access to 
    # this instance variable
    @search_id = params[:search_id]
    @researcher_id = params[:researcher_id]
    @search_results = SearchResult.where(search_id: @search_id)
  end

  # GET /researcher_rankings/1/edit
  def edit
  end

  # POST /researcher_rankings
  # POST /researcher_rankings.json
  def create
    @researcher_ranking = ResearcherRanking.new(researcher_ranking_params)

    respond_to do |format|
      if @researcher_ranking.save
        format.html { redirect_to @researcher_ranking, notice: 'Researcher ranking was successfully created.' }
        format.json { render action: 'show', status: :created, location: @researcher_ranking }
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
end
