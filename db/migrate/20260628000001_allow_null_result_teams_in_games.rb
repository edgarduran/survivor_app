class AllowNullResultTeamsInGames < ActiveRecord::Migration[8.0]
  def change
    change_column_null :games, :winning_team_id, true
    change_column_null :games, :losing_team_id, true
  end
end
