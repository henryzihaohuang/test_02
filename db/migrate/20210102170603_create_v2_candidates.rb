class CreateV2Candidates < ActiveRecord::Migration[6.0]
  def change
    create_table :v2_candidates do |t|
      t.bigint :uid, null: false
      t.string :full_name
      t.string :location
      t.float :latitude
      t.float :longitude
      t.text :bio
      t.string :industry
      t.string :email
      t.string :linked_in_url
      t.string :avatar_url

      t.timestamps
    end

    add_index :v2_candidates, :uid, unique: true
  end
end
