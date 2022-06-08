class DropV1Tables < ActiveRecord::Migration[6.0]
  def change
    drop_table :saved_candidates
    drop_table :candidates
    drop_table :pipelines
  end
end
