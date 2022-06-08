class CreateV2SavedCandidates < ActiveRecord::Migration[6.0]
  def change
    create_table :v2_saved_candidates do |t|
      t.belongs_to :v2_pipeline, null: false,
                                 index: true,
                                 foreign_key: { on_delete: :cascade }
      t.belongs_to :v2_candidate, null: false,
                                  index: true,
                                  foreign_key: { on_delete: :cascade }

      t.text :assessment
      t.text :status

      t.timestamps
    end

    add_index :v2_saved_candidates, [:v2_pipeline_id, :v2_candidate_id], unique: true
  end
end
