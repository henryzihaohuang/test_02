class CreateCandidates < ActiveRecord::Migration[6.0]
  def change
    create_table :candidates do |t|
      t.string :first_name
      t.string :last_name
      t.string :company_name
      t.string :titles, array: true
      t.string :city
      t.string :state
      t.string :country
      t.boolean :has_email
      t.string :inside_view_id
      t.json :raw_inside_view_data

      t.timestamps
    end

    add_index :candidates, :inside_view_id, unique: true
  end
end
