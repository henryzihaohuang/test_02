class CreateV2Pipelines < ActiveRecord::Migration[6.0]
  def change
    create_table :v2_pipelines do |t|
      t.belongs_to :user, null: false,
                          index: true,
                          foreign_key: { on_delete: :cascade }

      t.string :name, null: false

      t.timestamps
    end
  end
end
