require 'rails_helper'
require 'webmock/rspec'

RSpec.describe User, type: :model do
  describe 'Validation testing' do
    it 'line_uid is valid' do
      user = User.new(line_uid: 'U1234567890')
      expect(user).to be_valid
    end

    it 'line_uid is invalid' do
      user = User.new(line_uid: nil)
      expect(user).not_to be_valid
    end
  end

  describe '.get_weather' do
    let(:api_url) { "http://api.openweathermap.org/data/2.5/forecast?q=#{location},jp&APPID=#{ENV['WEATHER_APIKEY']}&lang=ja&units=metric" }
    let(:headers) { { 'Content-Type' => 'application/json' } }

    before { WebMock.stub_request(:get, api_url).to_return(status: status, body: response_body, headers: headers) }

    context 'when response is 200 OK' do
      let(:location) { 'Tokyo' }
      let(:status) { 200 }
      let(:response_body) do
        {
          city: { name: location },
          list: Array.new(40) do |i| #実際にAPIを叩くと40回分の予測データが取得できるので、ダミーデータも同じ数作成する
            {
              main: { temp_max: 25.567, temp_min: 18.432, humidity: 75 },
              weather: [{ description: '晴れ' }],
              dt_txt: "2025-02-02 12:00:00"
            }
          end
        }.to_json
      end

      it 'returns weather data for the city' do
        response = User.get_weather(location)
        expect(response).not_to be_nil
        expect(response[:city_name]).to eq('Tokyo')
        expect(response[:weather_forecasts].size).to eq(6) #　クライアントに送信する予測データが６つであるか

        first_forecast = response[:weather_forecasts].first
        expect(first_forecast[:temp_max]).to eq(25.57)
        expect(first_forecast[:temp_min]).to eq(18.43)
        expect(first_forecast[:humidity]).to eq(75)
        expect(first_forecast[:description]).to eq('晴れ')
        expect(first_forecast[:dt_txt]).to eq('2025年02月02日 12:00')
      end
    end

    context 'when location is invalid' do
      let(:location) { 'Hello' }
      let(:status) { 404 }
      let(:response_body) { '{"cod":"404","message":"city not found"}' }

      it 'returns nil' do
        response = User.get_weather(location)
        expect(response).to be_nil
      end
    end
  end
end

# 1.User.get_weather('Tokyo')
# 2.HTTParty.get で API を呼ぶが、Webmock によりモックされたデータを受け取る
# 3.受け取ったモックデータをもとに weather_forecasts を作成
# 4.定義された値と比較する