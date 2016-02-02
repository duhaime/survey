class ResearchersController < ApplicationController
  before_action :set_researcher, only: [:show, :edit, :update, :destroy]

  # GET /researchers
  # GET /researchers.json
  def index
    @researchers = Researcher.all
  end

  # GET /researchers/1
  # GET /researchers/1.json
  def show
  end

  # GET /researchers/new
  def new
    @researcher = Researcher.new
  end

  # GET /researchers/1/edit
  def edit
  end

  # POST /researchers
  # POST /researchers.json
  def create
    @researcher = Researcher.new(researcher_params)

    respond_to do |format|

      if @researcher.save
        format.html { redirect_to new_researcher_ranking_path(:researcher_id => @researcher.id, :search_id => retrieve_initial_search(@researcher)), action: show, notice: 'Success! Your information has been saved.', status: 301 }
        format.json { render action: 'show', status: :created, location: @researcher }
      else
        format.html { render action: 'new' }
        format.json { render json: @researcher.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /researchers/1
  # PATCH/PUT /researchers/1.json
  def update
    respond_to do |format|
      if @researcher.update(researcher_params)
        format.html { redirect_to @researcher, notice: 'Researcher was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @researcher.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /researchers/1
  # DELETE /researchers/1.json
  def destroy
    @researcher.destroy
    respond_to do |format|
      format.html { redirect_to researchers_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_researcher
      @researcher = Researcher.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def researcher_params
      params.require(:researcher).permit(:email, :name, :university, :position, :search_group_id)
    end

    # When a user successfully submits a form, retrieve their search_group_id, then find
    # the first search within that search group and send the researcher to that search page
    # with a get request to the show method
    def retrieve_initial_search(researcher_instance)
      researcher_search_group_id = researcher_instance.search_group_id

      # retrieve all searches for the given search_group_id
      relevant_searches = SearchGroup.where(search_group_id: researcher_search_group_id)

      # of those searches retrieve the first, and return its search id
      first_relevant_search = relevant_searches.first

      return first_relevant_search.search_id
    end  
end
