class ModerationAction < ApplicationRecord
  belongs_to :community
  belongs_to :target, polymorphic: true
  belongs_to :actor, class_name: "User", foreign_key: :actor_id

  enum action_type: { remove_post: 0, remove_comment: 1, ban_user: 2, unban_user: 3, pin_post: 4 }
end
