class AddMogulIdToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :mogul_id, :integer
  end
end
