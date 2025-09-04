class PicksController < ApplicationController

  def index
    # show all picks for season
    user = User.find(params[:user_id])
    season = Season.find(params[:season_id])

    picks = user.picks.where(season: season)
  end

  def show
    # current pick
  end

  def create
    # pick createable until lock time
    user = User.find(params[:user_id])
    # add before create callback in model to fetch current season
    season = Season.find(params[:season_id])
    # same callback for week
    week = Week.find(params[:week_id])
    team = Team.find([:team_id])

    pick = Pick.new(user: user, season: season, week: week, team: team)
    # add callback to verify pick valid (dup check, =< 2 incorrect picks, etc)

    if pick.save
      render json: { message: 'Pick Saved!'}, status: :success
    else
      render json: { errors: pick.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    #  verify this endpoint
    # pick changeable until lock time

    current_pick = Pick.find(params[:pick_id])


    if current_pick.update(team: team)
      render json: { message: 'Pick updated successfuly!'}, status: :success
    else
      render json: {message: current_pick.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    #  admin only action
    current_pick = Pick.find(params[:pick_id])

    if current_pick.delete
      render json: { message: 'User pick cleared!' }, status: :success
    else
      render json: { message: current.errors.full_messages }, status: :success
    end
  end

  private

  def pick_params
    params.permit(:user_id, :season_id, :week_id, :team_id)
  end

  def find_pick
    # maybe just establish all as instance var since create won't use @current_pick
    user = User.find(params[:user_id])
    season = Season.find(params[:season_id])
    week = Week.find(params[:week_id])
    team = Team.find([:team_id])

    @current_pick = Pick.find(user:user, season: season, week: week)
  end
end
