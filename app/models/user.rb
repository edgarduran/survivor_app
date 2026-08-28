class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[google_oauth2 facebook twitter]

  enum :role, { user: "user", super_admin: "super_admin" }, default: "user"

  has_many :oauth_identities, dependent: :destroy
  has_many :pool_memberships, dependent: :destroy
  has_many :pools, through: :pool_memberships
  has_many :picks

  def commissioner_of?(pool)
    pool_memberships.find_by(pool: pool)&.admin?
  end

  def can_manage_pool?(pool)
    super_admin? || commissioner_of?(pool)
  end
end
