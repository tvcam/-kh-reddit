class CreateNotifications < ActiveRecord::Migration[8.0]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.references :notifiable, polymorphic: true, null: false
      t.integer :notification_type, null: false, default: 0
      t.datetime :read_at
      t.jsonb :metadata, default: {}, null: false

      t.timestamps
    end
  end
end
