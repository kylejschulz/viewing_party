class Movie < ApplicationRecord
  has_many :parties, dependent: :destroy
end
