class AddDateBrandAndLocationToFillups < ActiveRecord::Migration[5.0]
  def change
    add_column :fillups, :fillup_date, :datetime
    add_column :fillups, :brand, :string
    add_column :fillups, :location, :string
  end
end
