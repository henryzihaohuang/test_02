class CandidatesController < ApplicationController
  def show
    @candidate = Candidate.find(params[:id])

    respond_to do |format|
      format.html
      format.pdf do
        render pdf: @candidate.full_name, layout: false
      end
    end
  end
end
