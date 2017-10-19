class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :github_login
      t.string :expo_push_token
      t.boolean :active
      t.timestamps
    end
  end
end
