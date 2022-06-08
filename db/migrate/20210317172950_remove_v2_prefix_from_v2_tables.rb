class RemoveV2PrefixFromV2Tables < ActiveRecord::Migration[6.1]
  def change
    rename_table :v2_saved_candidates, :saved_candidates
    rename_table :v2_educations, :educations
    rename_table :v2_experiences, :experiences
    rename_table :v2_candidates, :candidates
    rename_table :v2_pipelines, :pipelines

    rename_column :educations, :v2_candidate_id, :candidate_id
    rename_column :experiences, :v2_candidate_id, :candidate_id
    rename_column :saved_candidates, :v2_pipeline_id, :pipeline_id
    rename_column :saved_candidates, :v2_candidate_id, :candidate_id
  end
end
