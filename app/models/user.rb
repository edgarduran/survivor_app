class User < ApplicationRecord
  has_many :pool_memberships, dependent: :destroy
  has_many :pools, through: :pool_memberships
  has_many :picks

  def admin_of?(pool)
    pool_memberships.find_by(pool: pool)&.admin?
  end
end
