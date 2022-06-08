class AddIndexOnEmailToCandidates < ActiveRecord::Migration[6.1]
  def change
    add_index :candidates, :email
  end
end
