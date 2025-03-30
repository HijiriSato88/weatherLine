class AddIsReceiveReminderToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :is_receive_reminder, :boolean, default: false, null: false
  end
end
