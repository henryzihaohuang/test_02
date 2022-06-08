class AddLocationIndexToCandidates < ActiveRecord::Migration[6.1]
  def change
    add_index :candidates, :location
  end
end
