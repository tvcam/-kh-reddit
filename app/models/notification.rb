class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notifiable, polymorphic: true

  enum notification_type: { reply: 0, mention: 1, moderation: 2 }
end
