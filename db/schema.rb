# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170415002146) do

  create_table "cars", force: :cascade do |t|
    t.integer "year"
    t.string  "car_make"
    t.string  "car_model"
    t.string  "nickname"
    t.integer "mileage"
    t.integer "user_id"
  end

  create_table "fillups", force: :cascade do |t|
    t.integer  "mileage"
    t.float    "gallons"
    t.string   "octane"
    t.float    "price"
    t.integer  "car_id"
    t.datetime "fillup_date"
    t.string   "brand"
    t.string   "location"
  end

  create_table "services", force: :cascade do |t|
    t.integer  "mileage"
    t.datetime "service_date"
    t.string   "items"
    t.float    "price"
    t.string   "shop"
    t.string   "location"
    t.integer  "car_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.string "password_digest"
  end

end
