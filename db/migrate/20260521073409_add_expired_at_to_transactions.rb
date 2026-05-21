class AddExpiredAtToTransactions < ActiveRecord::Migration[8.1]
  def change
    add_column :transactions, :expired_at, :datetime
    add_index :transactions, :expired_at
  end
end
