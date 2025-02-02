require 'rails_helper'

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
    let(:response_body) { '{}' }
    let(:headers) { { 'Content-Type' => 'application/json' } }

    before { WebMock.stub_request(:get, api_url).to_return(status: status, body: response_body, headers: headers) }

    context 'when response is 200 OK' do
      let(:location) { 'Tokyo' }
      let(:status) { 200 }

      it 'returns a 200 OK response' do
        response = HTTParty.get(api_url)
        expect(response.code).to eq(200)
      end
    end

    context 'when miss send location' do
      let(:location) { 'Hello' }
      let(:status) { 404 }

      it 'returns a 404 response' do
        response = HTTParty.get(api_url)
        expect(response.code).to eq(404)
      end
    end
  end
end