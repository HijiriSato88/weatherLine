require 'line/bot'
require 'httparty'
require 'uri'

class LineBotController < ApplicationController
  def callback
    body = request.body.read

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      head 470
    end

    events = client.parse_events_from(body)

    events.each do |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          line_uid = event['source']['userId']
          message = event.message['text']
          user = User.find_or_create_by(line_uid: line_uid)
          weather = get_weather(message)

          if weather
            city = user.cities.find_or_create_by(city_name: message)
            weather_forecast = city.forecasts.create(
              temp_max: weather[:temp_max],
              temp_min: weather[:temp_min],
              temp_feel: weather[:temp_feel],
              humidity: weather[:humidity],
              description: weather[:description],
              rainfall: weather[:rainfall],
              date: weather[:date],
              aquired_at: Time.current
            )

            response_message = format_weather_response(weather_forecast)
          else
            response_message = "天気情報を取得できませんでした。正しい場所を入力してください。\n
                                例:Tokyo,Saitama,Kawagoe"
          end

          client.reply_message(event['replyToken'], { type: 'text', text: response_message })
        end
      end
    end
    head :ok
  end

  private

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV['LINE_CHANNEL_SECRET']
      config.channel_token = ENV['LINE_CHANNEL_TOKEN']
    }
  end

  def get_weather(location)
    api_key = ENV['WEATHER_APIKEY']
    response = HTTParty.get("https://api.openweathermap.org/data/2.5/weather?q=#{location},jp&appid=#{api_key}&lang=ja")

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

  def kelvin_to_celsius(kelvin)
    kelvin - 273.15
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
