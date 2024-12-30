class User < ApplicationRecord
    validates :line_uid, presence: true

    API_KEY = ENV['WEATHER_APIKEY']
	class << self
		def get_weather(location)
			response = HTTParty.get("http://api.openweathermap.org/data/2.5/forecast?q=#{location},jp&APPID=#{API_KEY}&lang=ja&units=metric")
			if response.success?
				data = response.parsed_response #HTTPartyのparsed_responseは解析されたJSONを返す
				{
					temp_max: (data['list'][1]['main']['temp_max']).round(2),
					temp_min: (data['list'][1]['main']['temp_min']).round(2),
					description: data['list'][1]['weather'][0]['description'],
					dt_txt: data['list'][1]['dt_txt'],
				}
			else
				Rails.logger.error("Weather API request failed: #{response.code} #{response.message}")
				nil
			end
		end

        def format_weather_response(weather_forecast)
            <<~TEXT
                日時: #{weather_forecast[:dt_txt]}
                天気: #{weather_forecast[:description]}
                気温: #{weather_forecast[:temp_min]}°C ~ #{weather_forecast[:temp_max]}°C
            TEXT
        end
	end
end
