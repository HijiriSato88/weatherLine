class LineBotController < ApplicationController
    def client
        @client ||= Line::Bot::Client.new { |config|
            config.channel_secret = ENV['LINE_CHANNEL_SECRET']
            config.channel_token = ENV['LINE_CHANNEL_TOKEN']
        }
    end

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
                if event.type == Line::Bot::Event::MessageType::Text
                    line_uid = event['source']['userId']
                    message = event.message['text'].strip
                    weather_forecasts = User.get_weather(message) # 複数の天気データを取得
                    if weather_forecasts
                        user = User.find_or_create_by(line_uid: line_uid)
                        puts weather_forecasts
                        response_message = User.format_weather_responses(weather_forecasts).strip
                    else
                        response_message = "天気情報を取得できませんでした。正しい場所を入力してください。
                                            例:Tokyo,Saitama,Kawagoe"
                    end
                    client.reply_message(event['replyToken'], { type: 'text', text: response_message })
                else
                    response_message = "そのメッセージには対応していません！"
                    client.reply_message(event['replyToken'], { type: 'text', text: response_message })
                end
            end
        end
        head :ok
    end
end
