class Week < ApplicationRecord
  belongs_to :season
  validates :week_number, presence: true, uniqueness: { scope: :season_id }
  validates :start_date, presence: true
end
