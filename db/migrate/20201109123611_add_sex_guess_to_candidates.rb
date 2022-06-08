class AddSexGuessToCandidates < ActiveRecord::Migration[6.0]
  def change
    add_column :candidates, :sex_guess, :string
  end
end
