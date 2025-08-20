class Comment < ApplicationRecord
  belongs_to :post, counter_cache: true
  belongs_to :user
  belongs_to :parent, class_name: "Comment", optional: true
  has_many :replies, class_name: "Comment", foreign_key: :parent_id, dependent: :destroy
  has_many :votes, as: :votable, dependent: :destroy

  validates :body, presence: true

  after_create_commit :set_materialized_path
  after_create_commit :notify_reply_and_mentions

  private

  def set_materialized_path
    update_column(:path, parent ? [parent.path, id].compact.join('/') : id.to_s)
  end

  def notify_reply_and_mentions
    if parent && parent.user_id != user_id
      Notification.create!(user_id: parent.user_id, notifiable: self, notification_type: :reply)
    end
    extract_mentions.each do |mentioned_user|
      next if mentioned_user.id == user_id
      Mention.create!(mentionable: self, mentioned_user_id: mentioned_user.id, context: body)
      Notification.create!(user_id: mentioned_user.id, notifiable: self, notification_type: :mention)
    end
  end

  def extract_mentions
    usernames = body.to_s.scan(/@([\p{L}\p{M}0-9_\.\-]+)/u).flatten.uniq.first(10)
    return [] if usernames.blank?
    User.where(username: usernames)
  end
end
