ActiveAdmin.register Tier do
  permit_params :name, :min_points, :bonus_rate

  filter :name
  filter :min_points
  filter :bonus_rate
  filter :created_at

  index do
    selectable_column
    id_column
    column :name
    column :min_points
    column :bonus_rate
    column :users_count do |tier|
      tier.users.count
    end
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :min_points
      row :bonus_rate
      row :created_at
      row :updated_at
    end

    panel "Users" do
      table_for resource.users.order(created_at: :desc) do
        column :id
        column :email
        column :role
        column :points_balance
        column :tier_points
        column :created_at
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :min_points
      f.input :bonus_rate
    end
    f.actions
  end
end
