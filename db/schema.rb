ActiveRecord::Schema[7.1].define(version: 2024_06_06_032448) do
  create_table "cities", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "city_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_cities_on_user_id"
  end

  create_table "forecasts", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "city_id", null: false
    t.float "temp_max", null: false
    t.float "temp_min", null: false
    t.float "temp_feel", null: false
    t.float "humidity", null: false
    t.string "description", null: false
    t.float "rainfall", null: false
    t.datetime "date", null: false
    t.datetime "aquired_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_id"], name: "index_forecasts_on_city_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "line_uid", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["line_uid"], name: "index_users_on_line_uid", unique: true
  end

  add_foreign_key "cities", "users"
  add_foreign_key "forecasts", "cities"
end
