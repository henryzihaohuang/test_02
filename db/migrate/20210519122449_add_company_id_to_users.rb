class AddCompanyIdToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :company_id, :integer, null: true, 
                                              index: true

    add_foreign_key :users, :users, column: :company_id
  end
end
