class Season < ApplicationRecord
  has_many :picks
  has_many :weeks
end
