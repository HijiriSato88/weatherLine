# LineBotController
class LineBotController < ApplicationController
  def client
    @client ||= Line::Bot::Client.new do |config|
      config.channel_secret = ENV.fetch('LINE_CHANNEL_SECRET', nil)
      config.channel_token = ENV.fetch('LINE_CHANNEL_TOKEN', nil)
    end
  end

  def callback
    body = request.body.read
    signature = request.env['HTTP_X_LINE_SIGNATURE']
    head 470 unless client.validate_signature(body, signature)

    events = client.parse_events_from(body)

    events.each do |event|
      handle_text_message(event) if text_message?(event)
    end

    head :ok
  end

  private

  def text_message?(event)
    event.is_a?(Line::Bot::Event::Message) && event.type == Line::Bot::Event::MessageType::Text
  end

  def handle_text_message(event)
    line_uid = event['source']['userId']
    client_message = event.message['text'].strip

    response_message = generate_response_message(line_uid, client_message)

    client.reply_message(event['replyToken'], { type: 'text', text: response_message })
  end

  def generate_response_message(line_uid, client_message)
    weather_forecasts = User.get_weather(client_message)

    if weather_forecasts
      User.find_or_create_by(line_uid: line_uid)
      User.format_weather_responses(weather_forecasts).strip
    else
      "天気情報を取得できませんでした。正しい場所を入力してください。\n例:Tokyo,Saitama,Kawagoe"
    end
  end
end
