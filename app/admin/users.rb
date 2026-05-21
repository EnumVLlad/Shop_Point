ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation, :role, :tier_id, :points_balance, :tier_points

  scope :all, default: true
  scope :admin
  scope :customer

  filter :email
  filter :role, as: :select, collection: User.roles.keys
  filter :tier
  filter :points_balance
  filter :tier_points
  filter :created_at

  index do
    selectable_column
    id_column
    column :email
    column :role
    column :tier
    column :points_balance
    column :tier_points
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :email
      row :role
      row :tier
      row :points_balance
      row :tier_points
      row :created_at
      row :updated_at
    end

    panel "Transactions" do
      table_for resource.transactions.recent do
        column :id
        column :order_number
        column :purchase_amount
        column :eligible_amount
        column :redeemed_points
        column :points
        column :status
        column :created_at
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :email
      f.input :role, as: :select, collection: User.roles.keys
      f.input :tier
      f.input :points_balance
      f.input :tier_points
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end
end
