class CreateGames < ActiveRecord::Migration[8.0]
  def change
    create_table :games do |t|
      t.datetime :kickoff_at, null: false
      t.string :external_id # NFL API's game ID — key for the adapter pattern
      t.integer :home_score
      t.integer :away_score
      t.string :status, null: false, default: "scheduled" # scheduled | in_progress | final
      t.references :week, null: false, foreign_key: true
      t.references :home_team, null: false, foreign_key: { to_table: :teams }
      t.references :away_team, null: false, foreign_key: { to_table: :teams }
      t.references :winning_team, null: false, foreign_key: { to_table: :teams }
      t.references :losing_team, null: false, foreign_key: { to_table: :teams }

      t.timestamps
    end
  end
end
