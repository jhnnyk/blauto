class CreateCars < ActiveRecord::Migration[5.0]
  def change
    create_table :cars do |t|
      t.integer :year
      t.string :make
      t.string :model
      t.string :nickname
      t.integer :mileage
      t.integer :user_id
    end
  end
end
