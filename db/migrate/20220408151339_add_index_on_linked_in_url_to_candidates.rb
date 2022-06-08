class AddIndexOnLinkedInUrlToCandidates < ActiveRecord::Migration[6.1]
  def change
    add_index :candidates, :linked_in_url
  end
end
