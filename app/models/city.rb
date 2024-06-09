class City < ApplicationRecord
    belongs_to :user
    has_many :forecasts
  
    API_KEY = ENV['WEATHER_APIKEY']
  
    # クラスメソッド
    def self.get_weather(location)
      response = HTTParty.get("https://api.openweathermap.org/data/2.5/weather?q=#{location},jp&appid=#{API_KEY}&lang=ja")
      if response.success?
        data = response.parsed_response
        {
          temp_max: kelvin_to_celsius(data['main']['temp_max']).round(2),
          temp_min: kelvin_to_celsius(data['main']['temp_min']).round(2),
          temp_feel: kelvin_to_celsius(data['main']['feels_like']).round(2),
          description: data["weather"][0]["description"],
          humidity: data["main"]["humidity"],
          rainfall: data['rain'] ? data['rain']['1h'] : 0,
          date: Time.current
        }
      else
        nil
      end
    end
  
    def self.format_weather_response(weather_forecast)
      <<~TEXT
        天気: #{weather_forecast.description}
        気温: #{weather_forecast.temp_min}°C ~ #{weather_forecast.temp_max}°C
        体感温度: #{weather_forecast.temp_feel}°C
        湿度: #{weather_forecast.humidity}%
        降水量: #{weather_forecast.rainfall}mm
      TEXT
    end
  
    private
    def kelvin_to_celsius(kelvin)
      kelvin - 273.15
    end
  end
  