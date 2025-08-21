class PicksController < ApplicationController

  def index
    # show all picks for season
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
      render json:{ message: 'Pick Saved!'}, status: :success
    else
      render json: { errors: pick.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    # pick changeable until lock time
  end

  def destroy
    #  admin only action
  end

  private

  def params
  end
end
