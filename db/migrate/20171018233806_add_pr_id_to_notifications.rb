class AddPrIdToNotifications < ActiveRecord::Migration[5.1]
  def change
    add_column :notifications, :pr_id, :integer, index: true
  end
end
