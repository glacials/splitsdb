# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20131101150937) do

  create_table "categories", force: true do |t|
    t.integer  "game_id"
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
  end

  add_index "categories", ["game_id"], name: "index_categories_on_game_id"
  add_index "categories", ["slug"], name: "index_categories_on_slug", unique: true

  create_table "games", force: true do |t|
    t.string   "name"
    t.string   "cover"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
  end

  add_index "games", ["slug"], name: "index_games_on_slug", unique: true

  create_table "runs", force: true do |t|
    t.integer  "category_id"
    t.integer  "user_id"
    t.string   "title"
    t.integer  "attempts"
    t.integer  "offset"
    t.string   "size"
    t.integer  "time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "video_url"
  end

  add_index "runs", ["category_id"], name: "index_runs_on_category_id"
  add_index "runs", ["user_id"], name: "index_runs_on_user_id"

  create_table "splits", force: true do |t|
    t.string   "name"
    t.integer  "run_id"
    t.integer  "old"
    t.integer  "best_run"
    t.integer  "best_segment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "splits", ["run_id"], name: "index_splits_on_run_id"

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "name"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
  end

  add_index "users", ["slug"], name: "index_users_on_slug", unique: true

end
