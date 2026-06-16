class RenameStartDateToPicksLockAtInWeek < ActiveRecord::Migration[8.0]
  def change
    rename_column :weeks, :start_date, :picks_lock_at
    add_column :weeks, :week_type, :string, default: "regular", null: false
  end
end
