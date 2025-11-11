class PoolMembership < ApplicationRecord
  belongs_to :pool
  belongs_to :user

  enum role: { member: "member", admin: "admin" }

  validates :pool_id, uniqueness: { scope: :user_id }
end
