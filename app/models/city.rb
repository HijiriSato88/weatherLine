class City < ApplicationRecord
    belongs_to :user
    has_many :forecasts
    validates :city_name, presence: true
end
  