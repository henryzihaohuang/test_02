class CreateV2Experiences < ActiveRecord::Migration[6.0]
  def change
    create_table :v2_experiences do |t|
      t.belongs_to :v2_candidate, null: false,
                          index: true,
                          foreign_key: { on_delete: :cascade }

      t.bigint :uid, null: false
      t.string :title
      t.string :employment_type
      t.string :company_name
      t.string :company_linked_in_url
      t.string :location
      t.float :latitude
      t.float :longitude
      t.integer :start_month
      t.integer :start_year
      t.integer :end_month
      t.integer :end_year
      t.text :description
      t.string :media_urls, array: true, default: []

      t.timestamps
    end

    add_index :v2_experiences, :uid, unique: true
  end
end
