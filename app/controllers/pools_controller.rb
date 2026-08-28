class PoolsController < ApplicationController
  before_action :set_pool, only: [:show, :status, :manage]
  before_action :require_super_admin!, only: [:new, :create]
  before_action :require_pool_manager!, only: [:manage]

  def new
    @pool = Pool.new
    @seasons = Season.all
  end

  def create
    @pool = Pool.new(pool_params)

    if @pool.save
      assign_commissioner
      redirect_to @pool, notice: "Pool created successfully!"
    else
      @seasons = Season.all
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @teams = Team.order(:name)
    @user_membership = @pool.pool_memberships.find_by(user: current_user)

    @current_week = @pool.season.weeks
                          .where("picks_lock_at > ?", Time.current)
                          .order(:week_number)
                          .first

    @all_picks = current_user.picks
                              .where(pool: @pool, season: @pool.season)
                              .includes(:team, :week)
                              .joins(:week)
                              .order("weeks.week_number")
                              .to_a

    @current_pick  = @all_picks.find { |p| p.week_id == @current_week&.id }
    @past_picks    = @all_picks.reject { |p| p.week_id == @current_week&.id }
    @used_team_ids = @past_picks.map(&:team_id)

    @incorrect_count = @all_picks.count { |p| p.is_correct == false }
    @is_eliminated   = @incorrect_count >= Pick::INCORRECT_PICK_LIMIT
    @picks_locked    = @current_week.nil? || Time.current >= @current_week.picks_lock_at
  end

  def manage
    @pending_invitations = @pool.invitations.where(accepted_at: nil).order(created_at: :desc)
    @members = @pool.pool_memberships.includes(:user).order(role: :desc, created_at: :asc)
  end

  def status
    memberships   = @pool.pool_memberships.includes(:user)
    picks_by_user = Pick.where(pool: @pool, season: @pool.season).group_by(&:user_id)

    @members = memberships.map do |membership|
      user_picks      = picks_by_user[membership.user_id] || []
      incorrect       = user_picks.count { |p| p.is_correct == false }
      {
        user:            membership.user,
        role:            membership.role,
        picks_count:     user_picks.count,
        incorrect_count: incorrect,
        eliminated:      incorrect >= Pick::INCORRECT_PICK_LIMIT
      }
    end.sort_by { |m| [m[:eliminated] ? 1 : 0, -m[:picks_count]] }
  end

  private

  def set_pool
    @pool = if current_user.super_admin?
      Pool.includes(:season, pool_memberships: :user).find(params[:id])
    else
      current_user.pools.includes(:season, pool_memberships: :user).find(params[:id])
    end
  end

  def assign_commissioner
    if params[:commissioner_type] == "self"
      @pool.pool_memberships.create!(user: current_user, role: "admin")
    elsif params[:commissioner_email].present?
      invitation = @pool.invitations.create!(
        email: params[:commissioner_email],
        role:  "admin",
        invited_by: current_user
      )
      # TODO: Replace with deliver_later once Sidekiq/Redis is configured
      InvitationMailer.invite(invitation).deliver_now
    end
  end

  def require_super_admin!
    unless current_user.super_admin?
      redirect_to root_path, alert: "Access denied."
    end
  end

  def require_pool_manager!
    unless current_user.can_manage_pool?(@pool)
      redirect_to @pool, alert: "Access denied."
    end
  end

  def pool_params
    params.require(:pool).permit(:name, :season_id)
  end
end
