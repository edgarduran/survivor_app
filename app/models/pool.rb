class Pool < ApplicationRecord
  belongs_to :season

  has_many :pool_memberships, dependent: :destroy
  has_many :users, through: :pool_memberships
  has_many :picks, dependent: :destroy
  has_many :invitations, dependent: :destroy

  validates :name, presence: true

  def commissioner
    pool_memberships.find_by(role: "admin")&.user
  end
end
