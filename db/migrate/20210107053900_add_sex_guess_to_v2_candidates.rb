class AddSexGuessToV2Candidates < ActiveRecord::Migration[6.0]
  def change
    add_column :v2_candidates, :sex_guess, :string
  end
end
