class Pick < ApplicationRecord
  belongs_to :user
  belongs_to :season
  belongs_to :week
  belongs_to :team

  validates :user_id, uniqueness: { scope: [:season_id, :team_id], message: "You already picked this team this season" }
end
