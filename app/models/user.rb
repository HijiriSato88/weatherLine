class User < ApplicationRecord
    validates :line_uid, presence: true

    API_KEY = ENV['WEATHER_APIKEY']
    class << self
        def get_weather(location)
            response = HTTParty.get("http://api.openweathermap.org/data/2.5/forecast?q=#{location},jp&APPID=#{API_KEY}&lang=ja&units=metric")
            if response.success?
                data = response.parsed_response
                city_name = data['city']['name']
                forecasts = data['list'][1..6].map do |item|
                    {
                        temp_max: (item['main']['temp_max']).round(2),
                        temp_min: (item['main']['temp_min']).round(2),
                        humidity: (item['main']['humidity']).round(2),
                        description: item['weather'][0]['description'],
                        dt_txt: item['dt_txt'],
                    }
                end
                { city_name: city_name, forecasts: forecasts }
            else
                Rails.logger.error("Weather API request failed: #{response.code} #{response.message}")
                nil
            end
        end

        def format_weather_responses(weather_data)
            city_name = weather_data[:city_name]
            forecasts = weather_data[:forecasts]

            message = "都市: #{city_name}\n\n"

            message += forecasts.map do |forecast|
                <<~TEXT
                    日時: #{forecast[:dt_txt]}
                    天気: #{forecast[:description]}
                    気温: #{forecast[:temp_min]}°C ~ #{forecast[:temp_max]}°C
                    湿度: #{forecast[:humidity]}%
                TEXT
            end.join("\n\n") #各テキストを区切る改行

            message
        end
    end
end
