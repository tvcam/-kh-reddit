class CreatePosts < ActiveRecord::Migration[8.0]
  def change
    create_table :posts do |t|
      t.references :community, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.text :body
      t.text :url
      t.jsonb :media_data
      t.integer :post_type, default: 0, null: false
      t.integer :score, default: 0, null: false
      t.integer :comments_count, default: 0, null: false
      t.boolean :pinned, default: false, null: false

      t.timestamps
    end
  end
end
