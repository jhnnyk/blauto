class ChangeCarColumnNames < ActiveRecord::Migration[5.0]
  def change
    rename_column :cars, :make, :car_make
    rename_column :cars, :model, :car_model
  end
end
