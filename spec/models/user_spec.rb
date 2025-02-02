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
end
