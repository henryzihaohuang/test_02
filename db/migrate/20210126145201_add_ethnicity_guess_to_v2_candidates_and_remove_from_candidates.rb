class AddEthnicityGuessToV2CandidatesAndRemoveFromCandidates < ActiveRecord::Migration[6.0]
  def change
    remove_column :candidates, :ethnicity_guess, :integer, default: 0,
                                                           null: false

    add_column :v2_candidates, :ethnicity_guess, :integer, default: 0,
                                                           null: false
  end
end
