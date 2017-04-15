class CreateServices < ActiveRecord::Migration[5.0]
  def change
    create_table :services do |t|
      t.integer :mileage
      t.datetime :service_date
      t.string :items
      t.float :price
      t.string :shop
      t.string :location
      t.integer :car_id
    end
  end
end
