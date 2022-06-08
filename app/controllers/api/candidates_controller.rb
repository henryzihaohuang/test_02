class Api::CandidatesController < Api::ApplicationController
  def save
    pipeline = current_user.pipelines.find(params[:pipeline_id])

    pipeline.saved_candidates.create!(candidate_id: params[:id])

    head :ok
  end

  def contact
    candidate = Candidate.find(params[:id])

    render status: :ok,
           json: {
             email: candidate.get_email,
             linked_in_url: candidate.linked_in_url
           }
  end
end
