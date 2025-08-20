class Community < ApplicationRecord
  enum visibility: { public_community: 0, restricted: 1, private_community: 2 }

  belongs_to :creator, class_name: "User"
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships
  has_many :posts, dependent: :destroy

  validates :name, presence: true, length: { maximum: 80 }
  validates :slug, presence: true, uniqueness: true

  before_validation :ensure_slug

  private

  def ensure_slug
    return if slug.present? && slug.parameterize == slug
    self.slug = name.to_s.parameterize
  end
end
