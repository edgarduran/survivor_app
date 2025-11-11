class AddPoolToPicks < ActiveRecord::Migration[8.0]
  def change
    add_reference :picks, :pool, null: false, foreign_key: true
  end
end
