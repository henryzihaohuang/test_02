class CreateV2Educations < ActiveRecord::Migration[6.0]
  def change
    create_table :v2_educations do |t|
      t.belongs_to :v2_candidate, null: false,
                          index: true,
                          foreign_key: { on_delete: :cascade }

      t.bigint :uid, null: false
      t.string :school_name
      t.string :degree
      t.integer :start_month
      t.integer :start_year
      t.integer :end_month
      t.integer :end_year
      t.text :description
      t.text :activities_and_societies

      t.timestamps
    end

    add_index :v2_educations, :uid, unique: true
  end
end
