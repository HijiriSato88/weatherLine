class Forecast < ApplicationRecord
    belongs_to :city

    validates :city_id, presence: true
    
    validates :temp_max, :temp_min, :temp_feel, presence: true, numericality: true
    
    validates :humidity, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

    validates :description, presence: true, length: { maximum: 255 }

    validates :rainfall, presence: true, numericality: { greater_than_or_equal_to: 0 }

    validates :date, presence: true
    
    validates :aquired_at, presence: true

    API_KEY = ENV['WEATHER_APIKEY']

    class << self
      def get_weather(location)
        response = HTTParty.get("https://api.openweathermap.org/data/2.5/weather?q=#{location},jp&appid=#{API_KEY}&lang=ja")
        if response.success?
          data = response.parsed_response #HTTPartyのparsed_responseは解析されたJSONを返す
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
    
      def format_weather_response(weather_forecast)
        message = 
        <<~TEXT
          天気: #{weather_forecast.description}
          気温: #{weather_forecast.temp_min}°C ~ #{weather_forecast.temp_max}°C
          体感温度: #{weather_forecast.temp_feel}°C
          湿度: #{weather_forecast.humidity}%
          降水量: #{weather_forecast.rainfall}mm
        TEXT
        message
      end
    
      private
      def kelvin_to_celsius(kelvin)
        kelvin - 273.15
      end
    end
end