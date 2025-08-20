class OtpCode < ApplicationRecord
  belongs_to :user

  enum channel: { sms: 0, whatsapp: 1 }

  validates :code, presence: true
  validates :expires_at, presence: true
  scope :active, -> { where(consumed_at: nil).where("expires_at > ?", Time.current) }
end
