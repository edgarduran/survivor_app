class Pick < ApplicationRecord
  belongs_to :user
  belongs_to :season
  belongs_to :week
  belongs_to :team
end
