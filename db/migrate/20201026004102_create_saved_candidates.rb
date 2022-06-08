class CreateSavedCandidates < ActiveRecord::Migration[6.0]
  def change
    create_table :saved_candidates do |t|
      t.belongs_to :pipeline, null: false,
                              foreign_key: true,
                              index: true
      t.belongs_to :candidate, null: false,
                               foreign_key: true,
                               index: true

      t.timestamps
    end

    add_index :saved_candidates, [:pipeline_id, :candidate_id], unique: true
  end
end
