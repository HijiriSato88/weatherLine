class CreateReminders < ActiveRecord::Migration[7.1]
  def change
    create_table :reminders do |t|
      t.references :user, null: false, foreign_key: true
      t.time :reminder_time
      t.string :location
      t.boolean :is_receive_reminder

      t.timestamps
    end
  end
end
