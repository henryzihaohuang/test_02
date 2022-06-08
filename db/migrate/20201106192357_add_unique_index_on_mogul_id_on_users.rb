class AddUniqueIndexOnMogulIdOnUsers < ActiveRecord::Migration[6.0]
  def change
    add_index :users, :mogul_id, unique: true
  end
end
