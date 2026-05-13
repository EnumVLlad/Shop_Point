class AddLoyaltyFieldsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_reference :users, :tier, null: true, foreign_key: true
    add_column :users, :points_balance, :integer, null: false, default: 0
  end
end
