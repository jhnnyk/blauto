class CreateFillups < ActiveRecord::Migration[5.0]
  def change
    create_table :fillups do |t|
      t.integer :mileage
      t.float :gallons
      t.string :octane
      t.float :price
      t.integer :car_id
    end
  end
end
