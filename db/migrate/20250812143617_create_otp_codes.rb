class CreateOtpCodes < ActiveRecord::Migration[8.0]
  def change
    create_table :otp_codes do |t|
      t.references :user, null: false, foreign_key: true
      t.string :code, null: false
      t.datetime :expires_at, null: false
      t.datetime :consumed_at
      t.integer :channel, null: false, default: 0
      t.jsonb :metadata, default: {}, null: false

      t.timestamps
    end
    add_index :otp_codes, :code
  end
end
