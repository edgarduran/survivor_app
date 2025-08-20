class CreateSeasons < ActiveRecord::Migration[8.0]
  def change
    create_table :seasons do |t|
      t.date :start_date
      t.date :end_date
      t.string :label

      t.timestamps
    end
  end
end
