class CreateAds < ActiveRecord::Migration[6.0]
  def change
    create_table :ads do |t|
      t.text :content
      t.string :username
      t.integer :author_telegram_id
      t.boolean :approved, default: false

      t.timestamps
    end
    add_index :ads, :username
    add_index :ads, :author_telegram_id
  end
end
