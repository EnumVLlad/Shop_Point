ActiveAdmin.register Transaction do
  actions :index, :show, :destroy

  filter :user
  filter :title
  filter :description
  filter :status
  filter :source
  filter :order_number
  filter :purchase_amount
  filter :eligible_amount
  filter :redeemed_points
  filter :points
  filter :created_at
  filter :expired_at

  index do
    selectable_column
    id_column
    column :user
    column :title
    column :order_number
    column :purchase_amount
    column :eligible_amount
    column :redeemed_points
    column :points
    column :status
    column :source
    column :expired_at
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :user
      row :title
      row :description
      row :status
      row :source
      row :order_number
      row :purchase_amount
      row :eligible_amount
      row :redeemed_points
      row :points
      row :expired_at
      row :created_at
      row :updated_at
    end
  end
end
