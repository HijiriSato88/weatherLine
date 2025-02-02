# frozen_string_literal: true

class User < ApplicationRecord
  validates :line_uid, presence: true

  API_KEY = ENV.fetch('WEATHER_APIKEY', nil)

  class << self
    def get_weather(location)
      response = HTTParty.get("http://api.openweathermap.org/data/2.5/forecast?q=#{location},jp&APPID=#{API_KEY}&lang=ja&units=metric")
      return nil unless response.success?

      parse_weather_data(response)
    end

    def parse_weather_data(response)
      city_name = response['city']['name']
      weather_forecasts = response['list'][2..7].map do |item|
        parse_forecast(item)
      end
      { city_name: city_name, weather_forecasts: weather_forecasts }
    end

    def parse_forecast(item)
      {
        temp_max: (item['main']['temp_max']).round(2),
        temp_min: (item['main']['temp_min']).round(2),
        humidity: (item['main']['humidity']).round(2),
        description: item['weather'][0]['description'],
        dt_txt: DateTime.parse(item['dt_txt']).strftime('%Y年%m月%d日 %H:%M')
      }
    end

    def format_weather_responses(weather_data)
      city_name = weather_data[:city_name]
      weather_forecasts = weather_data[:weather_forecasts]

      build_response_message(city_name, weather_forecasts)
    end

    def build_response_message(city_name, weather_forecasts)
      message = "現在付近の３時間毎の予報です。\n\n都市: #{city_name}\n\n"
      message += weather_forecasts.map { |forecast| format_forecast(forecast) }.join("\n\n")
      message
    end

    def format_forecast(forecast)
      <<~TEXT
        日時: #{forecast[:dt_txt]}
        天気: #{forecast[:description]}
        気温: #{forecast[:temp_min]}°C ~ #{forecast[:temp_max]}°C
        湿度: #{forecast[:humidity]}%
      TEXT
    end
  end
end
