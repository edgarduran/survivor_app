class Week < ApplicationRecord
  WEEK_TYPES = %w[regular wild_card divisional conference super_bowl].freeze

  belongs_to :season

  enum :week_type, WEEK_TYPES.index_with(&:itself), default: "regular"

  validates :week_number, presence: true, uniqueness: { scope: :season_id }
  validates :picks_lock_at, presence: true
  validates :week_type, inclusion: { in: WEEK_TYPES }
end
