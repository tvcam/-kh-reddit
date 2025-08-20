class CreateComments < ActiveRecord::Migration[8.0]
  def change
    create_table :comments do |t|
      t.references :post, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :parent_id, index: true
      t.text :body, null: false
      t.integer :score, default: 0, null: false
      t.text :path

      t.timestamps
    end
    add_foreign_key :comments, :comments, column: :parent_id
  end
end
