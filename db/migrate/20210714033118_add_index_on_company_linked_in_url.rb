class AddIndexOnCompanyLinkedInUrl < ActiveRecord::Migration[6.1]
  def change
    add_index :companies, :linked_in_url
  end
end
