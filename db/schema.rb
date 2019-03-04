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

ActiveRecord::Schema.define(version: 2019_03_04_184415) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "fly_sites", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.decimal "lat"
    t.decimal "lng"
    t.integer "hourstart"
    t.integer "hourend"
    t.integer "speedmin_ideal"
    t.integer "speedmax_ideal"
    t.integer "speedmin_edge"
    t.integer "speedmax_edge"
    t.string "dir_ideal", array: true
    t.string "dir_edge", array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
