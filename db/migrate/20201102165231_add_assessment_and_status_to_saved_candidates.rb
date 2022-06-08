class AddAssessmentAndStatusToSavedCandidates < ActiveRecord::Migration[6.0]
  def change
    add_column :saved_candidates, :assessment, :text
    add_column :saved_candidates, :status, :text
  end
end
