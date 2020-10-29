class CreateOwners < ActiveRecord::Migration[6.0]
  def change
    create_table :owners do |t|
      t.string  :username
      t.integer :telegram_id

      t.timestamps
    end
    add_index :owners, :username
    add_index :owners, :telegram_id
  end
end
