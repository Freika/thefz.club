class CreateModerators < ActiveRecord::Migration[6.0]
  def change
    create_table :moderators do |t|
      t.integer :telegram_id
      t.string :username

      t.timestamps
    end
    add_index :moderators, :telegram_id
    add_index :moderators, :username
  end
end
