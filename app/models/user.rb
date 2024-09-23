class User < ApplicationRecord
    has_many :cities
    validates :line_uid, presence: true
end
