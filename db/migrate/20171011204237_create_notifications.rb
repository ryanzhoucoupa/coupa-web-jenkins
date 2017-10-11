class CreateNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :notifications do |t|
      t.text :data
      t.string :to
      t.string :title
      t.string :body
      t.timestamps
    end
  end
end
