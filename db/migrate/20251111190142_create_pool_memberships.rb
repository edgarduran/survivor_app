class CreatePoolMemberships < ActiveRecord::Migration[8.0]
  def change
    create_table :pool_memberships do |t|
      t.references :pool, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :role

      t.timestamps
    end
  end
end
