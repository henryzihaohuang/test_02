class AddEthnicityGuessToCandidates < ActiveRecord::Migration[6.0]
  def change
    add_column :candidates, :ethnicity_guess, :integer, default: 0,
                                                        null: false
  end
end
