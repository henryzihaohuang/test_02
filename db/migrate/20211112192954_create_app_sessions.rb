class CreateAppSessions < ActiveRecord::Migration[6.1]
  def change
    create_table :app_sessions do |t|
      t.belongs_to :user, null: false,
                          foreign_key: { on_delete: :cascade },
                          index: true

      t.datetime :start_time, null: false
      t.integer :duration, default: 0,
                           null: false

      t.timestamps
    end
  end
end