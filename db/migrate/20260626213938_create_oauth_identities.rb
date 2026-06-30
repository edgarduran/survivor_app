class CreateOauthIdentities < ActiveRecord::Migration[8.0]
  def change
    create_table :oauth_identities do |t|
      t.references :user, null: false, foreign_key: true
      t.string :provider
      t.string :uid
      t.string :token
      t.string :secret

      t.timestamps
    end

    # Ensure a user can only have one identity per provider
    add_index :oauth_identities, [:provider, :uid], unique: true
    add_index :oauth_identities, [:user_id, :provider], unique: true
  end
end
