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
    let(:location) { 'Tokyo' }
    let(:api_url) { "http://api.openweathermap.org/data/2.5/forecast?q=#{location},jp&APPID=#{ENV['WEATHER_APIKEY']}&lang=ja&units=metric" }

    before do
        WebMock.stub_request(:get, api_url).to_return(status: 200, body: '{}', headers: { 'Content-Type' => 'application/json' })
    end

    it 'APIリクエストが200 OKを返すこと' do
      response = HTTParty.get(api_url)
      expect(response.code).to eq(200)
    end
  end
end
