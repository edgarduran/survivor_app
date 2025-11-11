class Pool < ApplicationRecord
  belongs_to :season
  belongs_to :admin, class_name: "User", optional: true

  has_many :pool_memberships, dependent: :destroy
  has_many :users, through: :pool_memberships
  has_many :picks, dependent: :destroy

  validates :name, presence: true
end
