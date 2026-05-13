class CreateTiers < ActiveRecord::Migration[8.1]
  def change
    create_table :tiers do |t|
      t.string :name, null: false
      t.integer :min_points, null: false, default: 0
      t.integer :bonus_rate, null: false, default: 1

      t.timestamps
    end

    add_index :tiers, :name, unique: true
  end
end
