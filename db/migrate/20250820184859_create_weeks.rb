class CreateWeeks < ActiveRecord::Migration[8.0]
  def change
    create_table :weeks do |t|
      t.integer :week_number
      t.datetime :start_date
      t.references :season, null: false, foreign_key: true

      t.timestamps
    end
  end
end
