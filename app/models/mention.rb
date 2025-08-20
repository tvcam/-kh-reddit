class Mention < ApplicationRecord
  belongs_to :mentionable, polymorphic: true
  belongs_to :mentioned_user, class_name: "User", foreign_key: :mentioned_user_id
end
