class PicksController < ApplicationController
  before_action :set_pool
  before_action :set_current_week
  before_action :set_pick, only: [:update]

  def create
    @pick = Pick.new(
      user:    current_user,
      pool:    @pool,
      season:  @pool.season,
      week:    @current_week,
      team_id: pick_params[:team_id]
    )

    if @pick.save
      redirect_to @pool, notice: "Pick saved — good luck!"
    else
      redirect_to @pool, alert: @pick.errors.full_messages.to_sentence
    end
  end

  def update
    @pick.team_id = pick_params[:team_id]

    if @pick.save
      redirect_to @pool, notice: "Pick updated!"
    else
      redirect_to @pool, alert: @pick.errors.full_messages.to_sentence
    end
  end

  private

  def set_pool
    @pool = current_user.pools.find(params[:pool_id])
  end

  def set_current_week
    @current_week = @pool.season.weeks
                          .where("picks_lock_at > ?", Time.current)
                          .order(:week_number)
                          .first
  end

  def set_pick
    @pick = current_user.picks.find(params[:id])
  end

  def pick_params
    params.require(:pick).permit(:team_id)
  end
end
