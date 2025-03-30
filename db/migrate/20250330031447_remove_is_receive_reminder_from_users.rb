class RemoveIsReceiveReminderFromUsers < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :is_receive_reminder, :boolean
  end
end
