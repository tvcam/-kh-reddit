class CreateModerationActions < ActiveRecord::Migration[8.0]
  def change
    create_table :moderation_actions do |t|
      t.references :community, null: false, foreign_key: true
      t.integer :actor_id, null: false
      t.references :target, polymorphic: true, null: false
      t.integer :action_type, null: false, default: 0
      t.text :reason
      t.jsonb :metadata, default: {}, null: false

      t.timestamps
    end
    add_foreign_key :moderation_actions, :users, column: :actor_id
  end
end
