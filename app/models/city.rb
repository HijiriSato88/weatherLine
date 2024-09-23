class City < ApplicationRecord
    belongs_to :user
    has_many :forecasts
    validates :user_id, :city_name, presence: true
end
  