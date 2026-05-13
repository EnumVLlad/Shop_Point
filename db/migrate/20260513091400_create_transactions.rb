class CreateTransactions < ActiveRecord::Migration[8.1]
  def change
    create_table :transactions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.string :description, null: false
      t.integer :points, null: false, default: 0
      t.string :status, null: false, default: "Completed"
      t.string :source, null: false, default: "purchase"
      t.string :order_number

      t.timestamps
    end

    add_index :transactions, :created_at
  end
end
