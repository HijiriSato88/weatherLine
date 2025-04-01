# ユーザが登録された地名、時間の天気予報をリマインドする
class WeatherRemindJob < ApplicationJob
    queue_as :default
  
    def perform
      Reminder.preload(:user).where(is_receive_reminder: true, reminder_time: notify_now_time.strftime('%H:%M:%S')).find_each do |reminder|
        weather_data = User.get_weather(reminder.location)
        next unless weather_data
  
        User.format_weather_responses(weather_data)
      end
    end
  
    private
  
    def notify_now_time
        now = Time.zone.now.change(min: 0, sec: 0)
    end
  end
  