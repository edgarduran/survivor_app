class Invitation < ApplicationRecord
  belongs_to :pool
  belongs_to :invited_by, class_name: "User"

  enum :role, { member: "member", admin: "admin" }, default: "member"

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :token, presence: true, uniqueness: true
  validates :email, uniqueness: { scope: :pool_id, message: "has already been invited to this pool" }

  before_validation :generate_token, on: :create

  def accepted?
    accepted_at.present?
  end

  private

  def generate_token
    self.token ||= SecureRandom.urlsafe_base64(32)
  end
end
