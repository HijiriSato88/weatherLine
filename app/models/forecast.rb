class Forecast < ApplicationRecord
	belongs_to :city

	with_options presence: true do
		validates :city_id
		validates :date
	end

	with_options presence: true, numericality: true do
		validates :temp_max, :temp_min, :temp_feel
		validates :rainfall, numericality: { greater_than_or_equal_to: 0 }
	end

	validates :humidity, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

	validates :description, presence: true, length: { maximum: 255 }

	API_KEY = ENV['WEATHER_APIKEY']

	class << self
		def get_weather(location)
			response = HTTParty.get("https://api.openweathermap.org/data/2.5/weather?q=#{location},jp&appid=#{API_KEY}&lang=ja")
			if response.success?
				data = response.parsed_response #HTTPartyのparsed_responseは解析されたJSONを返す
				{
					temp_max: (data['main']['temp_max'] - 273.15).round(2),
					temp_min: (data['main']['temp_min'] - 273.15).round(2),
					temp_feel: (data['main']['feels_like'] - 273.15).round(2),
					description: data["weather"][0]["description"],
					humidity: data["main"]["humidity"],
					rainfall: data['rain'] ? data['rain']['1h'] : 0,
					date: DateTime.now
				}
			else
				Rails.logger.error("Weather API request failed: #{response.code} #{response.message}")
				nil
			end
		end

		def format_weather_response(weather_forecast)
			<<~TEXT
				天気: #{weather_forecast.description}
				気温: #{weather_forecast.temp_min}°C ~ #{weather_forecast.temp_max}°C
				体感温度: #{weather_forecast.temp_feel}°C
				湿度: #{weather_forecast.humidity}%
				降水量: #{weather_forecast.rainfall}mm
			TEXT
		end
	end
end
