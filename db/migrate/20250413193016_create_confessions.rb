class CreateConfessions < ActiveRecord::Migration[8.0]
  def change
    create_table :confessions do |t|
      t.text :body, null: false
      t.string :ip_address, null: false
      t.integer :reactions_count, default: 0, null: false

      t.timestamps
    end

    add_index :confessions, :ip_address
    add_index :confessions, :created_at
    add_index :confessions, :reactions_count
  end
end
