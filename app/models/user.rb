class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[google_oauth2 facebook twitter]

  has_many :oauth_identities, dependent: :destroy
  has_many :pool_memberships, dependent: :destroy
  has_many :pools, through: :pool_memberships
  has_many :picks

  def admin_of?(pool)
    pool_memberships.find_by(pool: pool)&.admin?
  end
end
