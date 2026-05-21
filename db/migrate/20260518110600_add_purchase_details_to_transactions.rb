class AddPurchaseDetailsToTransactions < ActiveRecord::Migration[8.1]
  def change
    add_column :transactions, :purchase_amount, :decimal, precision: 10, scale: 2
    add_column :transactions, :eligible_amount, :decimal, precision: 10, scale: 2
    add_column :transactions, :redeemed_points, :integer, default: 0, null: false
  end
end
