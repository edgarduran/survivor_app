# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2026_06_28_000001) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "games", force: :cascade do |t|
    t.datetime "kickoff_at", null: false
    t.string "external_id"
    t.integer "home_score"
    t.integer "away_score"
    t.string "status", default: "scheduled", null: false
    t.bigint "week_id", null: false
    t.bigint "home_team_id", null: false
    t.bigint "away_team_id", null: false
    t.bigint "winning_team_id"
    t.bigint "losing_team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["away_team_id"], name: "index_games_on_away_team_id"
    t.index ["home_team_id"], name: "index_games_on_home_team_id"
    t.index ["losing_team_id"], name: "index_games_on_losing_team_id"
    t.index ["week_id"], name: "index_games_on_week_id"
    t.index ["winning_team_id"], name: "index_games_on_winning_team_id"
  end

  create_table "oauth_identities", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "provider"
    t.string "uid"
    t.string "token"
    t.string "secret"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider", "uid"], name: "index_oauth_identities_on_provider_and_uid", unique: true
    t.index ["user_id", "provider"], name: "index_oauth_identities_on_user_id_and_provider", unique: true
    t.index ["user_id"], name: "index_oauth_identities_on_user_id"
  end

  create_table "picks", force: :cascade do |t|
    t.boolean "is_correct"
    t.bigint "user_id", null: false
    t.bigint "season_id", null: false
    t.bigint "week_id", null: false
    t.bigint "team_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "pool_id", null: false
    t.index ["pool_id"], name: "index_picks_on_pool_id"
    t.index ["season_id"], name: "index_picks_on_season_id"
    t.index ["team_id"], name: "index_picks_on_team_id"
    t.index ["user_id"], name: "index_picks_on_user_id"
    t.index ["week_id"], name: "index_picks_on_week_id"
  end

  create_table "pool_memberships", force: :cascade do |t|
    t.bigint "pool_id", null: false
    t.bigint "user_id", null: false
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pool_id"], name: "index_pool_memberships_on_pool_id"
    t.index ["user_id"], name: "index_pool_memberships_on_user_id"
  end

  create_table "pools", force: :cascade do |t|
    t.string "name"
    t.bigint "season_id", null: false
    t.integer "admin_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_id"], name: "index_pools_on_admin_id"
    t.index ["season_id"], name: "index_pools_on_season_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "seasons", force: :cascade do |t|
    t.date "start_date"
    t.date "end_date"
    t.string "label"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "username"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "weeks", force: :cascade do |t|
    t.integer "week_number"
    t.datetime "picks_lock_at"
    t.bigint "season_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "week_type", default: "regular", null: false
    t.index ["season_id"], name: "index_weeks_on_season_id"
  end

  add_foreign_key "games", "teams", column: "away_team_id"
  add_foreign_key "games", "teams", column: "home_team_id"
  add_foreign_key "games", "teams", column: "losing_team_id"
  add_foreign_key "games", "teams", column: "winning_team_id"
  add_foreign_key "games", "weeks"
  add_foreign_key "oauth_identities", "users"
  add_foreign_key "picks", "pools"
  add_foreign_key "picks", "seasons"
  add_foreign_key "picks", "teams"
  add_foreign_key "picks", "users"
  add_foreign_key "picks", "weeks"
  add_foreign_key "pool_memberships", "pools"
  add_foreign_key "pool_memberships", "users"
  add_foreign_key "pools", "seasons"
  add_foreign_key "weeks", "seasons"
end
