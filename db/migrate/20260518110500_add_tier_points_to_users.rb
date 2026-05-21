class AddTierPointsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :tier_points, :integer, default: 0, null: false
  end
end
