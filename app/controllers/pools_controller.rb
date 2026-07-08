class PoolsController < ApplicationController
  before_action :set_pool, only: [:show]

  def new
    @pool = Pool.new
    @seasons = Season.all
  end

  def create
    @pool = Pool.new(pool_params)
    @pool.admin = current_user

    if @pool.save
      @pool.pool_memberships.create!(user: current_user, role: "admin")
      redirect_to @pool, notice: "Pool created successfully!"
    else
      @seasons = Season.all
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  private

  def set_pool
    @pool = current_user.pools.includes(:season, pool_memberships: :user).find(params[:id])
  end

  def pool_params
    params.require(:pool).permit(:name, :season_id)
  end
end
