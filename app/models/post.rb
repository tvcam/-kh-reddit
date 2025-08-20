class Post < ApplicationRecord
  enum post_type: { text: 0, link: 1, media: 2 }
  scope :pinned_first, -> { order(Arel.sql("pinned DESC, created_at DESC")) }

  belongs_to :community, counter_cache: true
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :votes, as: :votable, dependent: :destroy
  has_many_attached :media

  validates :title, presence: true, length: { maximum: 300 }
  validates :post_type, presence: true
end
