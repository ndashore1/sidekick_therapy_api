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

ActiveRecord::Schema.define(version: 2021_08_19_130805) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "goals", force: :cascade do |t|
    t.string "name"
    t.boolean "is_completed"
    t.integer "goal_type"
    t.jsonb "note"
    t.bigint "user_id", null: false
    t.bigint "plan_of_care_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["plan_of_care_id"], name: "index_goals_on_plan_of_care_id"
    t.index ["user_id"], name: "index_goals_on_user_id"
  end

  create_table "patient_histories", force: :cascade do |t|
    t.string "comments"
    t.bigint "patient_id", null: false
    t.bigint "plan_of_care_id", null: false
    t.bigint "old_therapists_id"
    t.bigint "new_therapists_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["new_therapists_id"], name: "index_patient_histories_on_new_therapists_id"
    t.index ["old_therapists_id"], name: "index_patient_histories_on_old_therapists_id"
    t.index ["patient_id"], name: "index_patient_histories_on_patient_id"
    t.index ["plan_of_care_id"], name: "index_patient_histories_on_plan_of_care_id"
  end

  create_table "plan_of_cares", force: :cascade do |t|
    t.string "title"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_plan_of_cares_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "email", default: "", null: false
    t.string "password_digest"
    t.integer "age"
    t.integer "gender"
    t.integer "user_type", default: 0, null: false
    t.text "address"
    t.string "phone_number"
    t.string "auth_token"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "goals", "plan_of_cares"
  add_foreign_key "goals", "users"
  add_foreign_key "patient_histories", "plan_of_cares"
  add_foreign_key "patient_histories", "users", column: "new_therapists_id"
  add_foreign_key "patient_histories", "users", column: "old_therapists_id"
  add_foreign_key "patient_histories", "users", column: "patient_id"
  add_foreign_key "plan_of_cares", "users"
end
