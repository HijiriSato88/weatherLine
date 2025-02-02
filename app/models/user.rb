# frozen_string_literal: true

class User < ApplicationRecord
  validates :line_uid, presence: true

  API_KEY = ENV.fetch('WEATHER_APIKEY', nil)
  class << self
    def get_weather(location)
      response = HTTParty.get("http://api.openweathermap.org/data/2.5/forecast?q=#{location},jp&APPID=#{API_KEY}&lang=ja&units=metric")
      if response.success?
        city_name = response['city']['name']
        weather_forecasts = response['list'][2..7].map do |item|
          {
            temp_max: (item['main']['temp_max']).round(2), # 小数点以下2桁に丸める.以下同様.
            temp_min: (item['main']['temp_min']).round(2),
            humidity: (item['main']['humidity']).round(2),
            description: item['weather'][0]['description'],
            dt_txt: DateTime.parse(item['dt_txt']).strftime('%Y年%m月%d日 %H:%M')
          }
        end
        { city_name: city_name, weather_forecasts: weather_forecasts }
      else
        Rails.logger.error("Weather API request failed: #{response.code} #{response.message}")
        nil
      end
    end

    def format_weather_responses(weather_data)
      city_name = weather_data[:city_name]
      weather_forecasts = weather_data[:weather_forecasts]

      response_message = " 現在付近の３時間毎の予報です。\n\n都市: #{city_name}\n\n"

      response_message += weather_forecasts.map do |forecast|
        <<~TEXT
          日時: #{forecast[:dt_txt]}
          天気: #{forecast[:description]}
          気温: #{forecast[:temp_min]}°C ~ #{forecast[:temp_max]}°C
          湿度: #{forecast[:humidity]}%
        TEXT
      end.join("\n\n") # 各テキストを区切る改行

      response_message
    end
  end
end
