class InstructionController < ApplicationController
  def show
    @researcher_email = params[:email]
  end
end
