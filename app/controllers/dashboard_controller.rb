class DashboardController < ApplicationController

  def index
    @pools = current_user.pools.includes(:season, :pool_memberships)
  end
end
