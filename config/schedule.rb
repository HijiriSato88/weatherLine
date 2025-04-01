# config/schedule.rb

set :output, "log/cron.log"
set :environment, ENV['RAILS_ENV'] || 'development'

every 1.hour, at: '00:00' do
  runner "WeatherRemindJob.perform_later"
end
