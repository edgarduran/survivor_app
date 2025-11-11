class CreatePools < ActiveRecord::Migration[8.0]
  def change
    create_table :pools do |t|
      t.string :name
      t.references :season, null: false, foreign_key: true
      t.integer :admin_id

      t.timestamps
    end
    add_index :pools, :admin_id
  end
end
