class LineBotController < ApplicationController
    def client
        #@clientが未定義の場合のみ,新しいクライアントを作成
        @client ||= Line::Bot::Client.new { |config|
            config.channel_secret = ENV.fetch('LINE_CHANNEL_SECRET', nil)
            config.channel_token = ENV.fetch('LINE_CHANNEL_TOKEN', nil)
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
                    client_message = event.message['text'].strip
                    weather_forecasts = User.get_weather(client_message) #クライアントからの地名メッセージを基に、天気予報を取得
                    if weather_forecasts
                        user = User.find_or_create_by(line_uid: line_uid)
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
