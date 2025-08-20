class CreateCommunities < ActiveRecord::Migration[8.0]
  def change
    create_table :communities do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.text :description
      t.text :rules
      t.integer :members_count, default: 0, null: false
      t.integer :posts_count, default: 0, null: false
      t.integer :visibility, default: 0, null: false
      t.boolean :nsfw, default: false, null: false
      t.references :creator, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
    add_index :communities, :slug, unique: true
  end
end
