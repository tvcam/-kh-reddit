class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :value, inclusion: { in: [-1, 1] }
  validates :user_id, uniqueness: { scope: %i[votable_id votable_type], message: "has already voted" }

  after_commit :recompute_author_karma, on: %i[create update destroy]

  private

  def recompute_author_karma
    author = case votable
             when Post then votable.user
             when Comment then votable.user
             else nil
             end
    return unless author
    post_karma = Vote.joins("JOIN posts ON votes.votable_id = posts.id AND votes.votable_type='Post'").where("posts.user_id = ?", author.id).sum(:value)
    comment_karma = Vote.joins("JOIN comments ON votes.votable_id = comments.id AND votes.votable_type='Comment'").where("comments.user_id = ?", author.id).sum(:value)
    author.update_column(:karma, post_karma + comment_karma)
  end
end
