require 'base64'

class ResearchersController < ApplicationController
  before_action :set_researcher, only: [:show]

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

  # POST /researchers
  # POST /researchers.json
  def create
    """
    on save of researcher form, send the researcher's email 
    and their current question number (0) to the researcher
    rankings controller
    """
    @researcher = Researcher.new(researcher_params)

    respond_to do |format|

      if @researcher.save
        format.html { redirect_to controller: 'instruction', action: 'show', email: @researcher.email }

        format.json { render action: 'show', status: :created, location: @researcher }
      else
        format.html { render action: 'new' }
        format.json { render json: @researcher.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_researcher
      @researcher = Researcher.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def researcher_params
      params.require(:researcher).permit(:email, :name, :university, :position, :search_group_id, :frequency_of_database_usage, :do_you_know_proquest, :do_you_like_proquest)
    end
end
