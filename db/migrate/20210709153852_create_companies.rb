class CreateCompanies < ActiveRecord::Migration[6.1]
  def change
    create_table :companies do |t|
      t.bigint :uid, null: false
      t.string :name
      t.string :location
      t.string :industry
      t.string :website
      t.integer :founded
      t.text :bio
      t.integer :employees_count
      t.string :linked_in_url

      t.timestamps
    end

    add_index :companies, :uid, unique: true
  end
end
