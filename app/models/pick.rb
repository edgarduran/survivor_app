class Pick < ApplicationRecord
  belongs_to :user
  belongs_to :season
  belongs_to :week
  belongs_to :team

  validates :user_id, uniqueness: { scope: [:season_id, :team_id], message: "You already picked this team this season" }
  validate :pick_in_before_week_kickoff, on: [:create, :update]
  # validates start_date: { before: :week_start_date, message: "Cannot make or change pick after week has started" }


  def pick_in_before_week_kickoff
    if week.start_date < Time.current
      errors.add(:base, "You cannot make or change a pick after the start of the week's first game.")
    end
  end
end
