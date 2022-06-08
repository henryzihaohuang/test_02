class Api::SavedCandidatesController < Api::ApplicationController
  def update
    saved_candidate = current_user.saved_candidates.find(params[:id])

    saved_candidate.update!(saved_candidate_params)

    head :ok
  end

  private

  def saved_candidate_params
    params.require(:saved_candidate).permit(:assessment,
                                            :status,
                                            resume: :data)
  end
end
