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

ActiveRecord::Schema.define(version: 2019_04_30_214215) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "hstore"
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
    t.jsonb "nws_meta_data", default: {}
  end

  create_table "fly_sites_users", id: false, force: :cascade do |t|
    t.bigint "fly_site_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["fly_site_id"], name: "index_fly_sites_users_on_fly_site_id"
    t.index ["user_id"], name: "index_fly_sites_users_on_user_id"
  end

  create_table "flyability_scores", force: :cascade do |t|
    t.bigint "fly_site_id"
    t.hstore "scores", default: {}, null: false
    t.string "calculation_version"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "score_details", default: {}
    t.index ["fly_site_id"], name: "index_flyability_scores_on_fly_site_id"
  end

  create_table "forecasts", force: :cascade do |t|
    t.bigint "fly_site_id"
    t.string "source"
    t.datetime "data_updated_at"
    t.jsonb "data", default: "{}", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["fly_site_id"], name: "index_forecasts_on_fly_site_id"
    t.index ["source", "fly_site_id", "data_updated_at"], name: "index_forecasts_on_source_and_fly_site_id_and_data_updated_at"
  end

  create_table "hourly_forecasts", force: :cascade do |t|
    t.bigint "fly_site_id"
    t.string "source"
    t.datetime "data_updated_at"
    t.datetime "start_time"
    t.jsonb "data", default: "{}", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["fly_site_id"], name: "index_hourly_forecasts_on_fly_site_id"
    t.index ["source", "fly_site_id", "start_time"], name: "index_hourly_forecasts_on_source_and_fly_site_id_and_start_time", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "provider"
    t.string "uid"
    t.string "name"
    t.text "image"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
