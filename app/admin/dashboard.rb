ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: "Dashboard"

  content title: "Shop Point Admin" do
    columns do
      column do
        panel "Users" do
          attributes_table_for OpenStruct.new(total: User.count, customers: User.customer.count, admins: User.admin.count) do
            row :total
            row :customers
            row :admins
          end
        end
      end

      column do
        panel "Transactions" do
          attributes_table_for OpenStruct.new(total: Transaction.count, points: Transaction.sum(:points)) do
            row :total
            row :points
          end
        end
      end

      column do
        panel "Tiers" do
          attributes_table_for OpenStruct.new(total: Tier.count) do
            row :total
          end
        end
      end
    end

    panel "Recent Transactions" do
      table_for Transaction.includes(:user).recent.limit(10) do
        column :id
        column :user
        column :order_number
        column :purchase_amount
        column :redeemed_points
        column :points
        column :status
        column :created_at
      end
    end
  end
end
