class Membership < ApplicationRecord
  enum role: { member: 0, moderator: 1, admin: 2 }
  enum status: { active: 0, banned: 1, pending: 2 }

  belongs_to :user
  belongs_to :community, counter_cache: :members_count

  validates :role, :status, presence: true
  validates :user_id, uniqueness: { scope: :community_id }
end
