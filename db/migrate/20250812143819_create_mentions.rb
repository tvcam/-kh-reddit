class CreateMentions < ActiveRecord::Migration[8.0]
  def change
    create_table :mentions do |t|
      t.references :mentionable, polymorphic: true, null: false
      t.integer :mentioned_user_id, null: false
      t.text :context

      t.timestamps
    end
    add_foreign_key :mentions, :users, column: :mentioned_user_id
  end
end
