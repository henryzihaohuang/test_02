class MakeForeignKeysCascade < ActiveRecord::Migration[6.0]
  def change
    remove_foreign_key :pipelines, :users
    remove_foreign_key :saved_candidates, :candidates
    remove_foreign_key :saved_candidates, :pipelines
    add_foreign_key :pipelines, :users, on_delete: :cascade
    add_foreign_key :saved_candidates, :candidates, on_delete: :cascade
    add_foreign_key :saved_candidates, :pipelines, on_delete: :cascade
  end
end
