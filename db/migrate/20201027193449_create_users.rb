class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :auth_token, null: false

      t.timestamps
    end

    execute 'CREATE UNIQUE INDEX index_users_on_lowercase_email ON users USING btree (lower(email));'
    add_index :users, :auth_token, unique: true
  end
end
