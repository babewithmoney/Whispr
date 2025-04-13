class CreateReactions < ActiveRecord::Migration[8.0]
  def change
    create_table :reactions do |t|
      t.references :confession, null: false, foreign_key: true
      t.string :reaction_type, null: false
      t.string :ip_address, null: false

      t.timestamps
    end

    add_index :reactions, [:confession_id, :ip_address], unique: true
    add_index :reactions, :created_at
    add_index :reactions, :reaction_type
  end
end
