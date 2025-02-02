# frozen_string_literal: true

# Userモデルのテスト
require 'rails_helper'
require 'webmock/rspec'

RSpec.describe User, type: :model do
  describe 'Validation testing' do
    it 'is valid with a line_uid' do
      user = described_class.new(line_uid: 'U1234567890')
      expect(user).to be_valid
    end

    it 'is invalid without a line_uid' do
      user = described_class.new(line_uid: nil)
      expect(user).not_to be_valid
    end
  end

  describe '.get_weather' do
    let(:location) { 'Tokyo' }
    let(:api_url) { "http://api.openweathermap.org/data/2.5/forecast?q=#{location},jp&APPID=#{ENV.fetch('WEATHER_APIKEY', nil)}&lang=ja&units=metric" }
    let(:headers) { { 'Content-Type' => 'application/json' } }
    let(:response_body) do
      {
        city: { name: location },
        list: Array.new(40) do
          {
            main: { temp_max: 25.567, temp_min: 18.432, humidity: 75 },
            weather: [{ description: '晴れ' }],
            dt_txt: '2025-02-02 12:00:00'
          }
        end
      }.to_json
    end

    context 'when response is 200 OK' do
      before do
        WebMock.stub_request(:get, api_url).to_return(status: 200, body: response_body, headers: headers)
      end

      let(:parsed_response) { described_class.get_weather(location) }

      it 'returns a non-nil response' do
        expect(parsed_response).not_to be_nil
      end

      it 'includes the correct city name' do
        expect(parsed_response[:city_name]).to eq('Tokyo')
      end

      it 'contains exactly 6 weather forecasts' do
        expect(parsed_response[:weather_forecasts].size).to eq(6)
      end

      it 'has the correct max temperature' do
        expect(parsed_response[:weather_forecasts].first[:temp_max]).to eq(25.57)
      end

      it 'has the correct min temperature' do
        expect(parsed_response[:weather_forecasts].first[:temp_min]).to eq(18.43)
      end

      it 'has the correct humidity' do
        expect(parsed_response[:weather_forecasts].first[:humidity]).to eq(75)
      end

      it 'has the correct weather description' do
        expect(parsed_response[:weather_forecasts].first[:description]).to eq('晴れ')
      end

      it 'has the correct date format' do
        expect(parsed_response[:weather_forecasts].first[:dt_txt]).to eq('2025年02月02日 12:00')
      end
    end

    context 'when location is invalid' do
      let(:location) { 'Hello' }

      before { WebMock.stub_request(:get, api_url).to_return(status: 404, body: '{"cod":"404","message":"city not found"}', headers: headers) }

      it 'returns nil' do
        response = described_class.get_weather(location)
        expect(response).to be_nil
      end
    end
  end
end
