class CreateSearchPerformeds < ActiveRecord::Migration[6.1]
  def change
    create_table :search_performeds do |t|
      t.belongs_to :user, null: false,
                          foreign_key: true,
                          index: true

      t.text :query
      t.json :filters, default: {}
      t.integer :page
      t.integer :per_page

      t.timestamps
    end
  end
end