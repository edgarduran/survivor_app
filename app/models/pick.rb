class Pick < ApplicationRecord
  belongs_to :user
  belongs_to :pool
  belongs_to :season
  belongs_to :week
  belongs_to :team

  validates :user, :season, :week, :team, presence: true
  validates :team_id, uniqueness: { scope: [:user_id, :season_id], message: "You've already picked this team this season" }
  validate :pick_in_before_week_kickoff, on: [:create, :update]
  validate :user_not_exceeded_incorrect_picks, on: :create
  validate :pick_made_before_week_start
  validate :one_pick_per_week_per_user, on: :create

  INCORRECT_PICK_LIMIT = 2

  private

  def pick_in_before_week_kickoff
    if week.start_date < Time.current
      errors.add(:base, "You cannot make or change a pick after the start of the week's first game.")
    end
  end

  def user_not_exceeded_incorrect_picks
    return if user_id.blank? || season_id.blank?

    incorrect_picks = Pick.where(user_id:, season_id:)
                      .where(is_correct: false)
                      .count

    if incorrect_picks >= INCORRECT_PICK_LIMIT
      errors.add(:base, "You have already made #{INCORRECT_PICK_LIMIT} incorrect picks this season and cannot make any more picks.")
    end
  end

  def pick_made_before_week_start
    return if week.blank? || week.start_date.blank?
    return if created_at.present? && created_at < week.start_date

    if Time.current > week.start_date
      errors.add(:base, "You cannot make or change a pick after the start of the week's first game.")
    end
  end

  def one_pick_per_week_per_user
    return if user_id.blank? || week_id.blank? || season_id.blank?

    if Pick.exists?(user_id: user_id, week_id: week_id, season_id: season_id)
      errors.add(:base, "You already have a pick for this week. You can change it until the week starts.")
    end
  end
end
