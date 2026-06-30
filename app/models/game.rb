class Game < ApplicationRecord
  STATUSES = %w[scheduled in_progress final].freeze

  belongs_to :week
  belongs_to :home_team, class_name: "Team"
  belongs_to :away_team, class_name: "Team"
  belongs_to :winning_team, class_name: "Team", optional: true
  belongs_to :losing_team, class_name: "Team", optional: true

  enum :status, STATUSES.index_with(&:itself), default: "scheduled"

  validates :kickoff_at, presence: true
  validates :status, inclusion: { in: STATUSES }
  validates :external_id, uniqueness: true, allow_nil: true
end
