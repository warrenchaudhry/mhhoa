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

ActiveRecord::Schema.define(version: 2019_03_01_115117) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "employees", force: :cascade do |t|
    t.string "firstname"
    t.string "lastname"
    t.date "start_date"
    t.date "end_date"
    t.integer "employee_type", default: 0
    t.decimal "rate", default: "0.0"
    t.integer "payment_mode", default: 0
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "homeowners", force: :cascade do |t|
    t.string "firstname"
    t.string "mi"
    t.string "lastname"
    t.bigint "street_id"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "payment_starts_on", default: "2012-01-01"
    t.decimal "monthly_dues_discount", precision: 8, scale: 2, default: "0.0"
    t.integer "position", default: 0
    t.index ["street_id"], name: "index_homeowners_on_street_id"
  end

  create_table "monthly_due_payments", force: :cascade do |t|
    t.bigint "homeowner_id"
    t.bigint "monthly_due_rate_id"
    t.decimal "amount", precision: 8, scale: 2, default: "0.0"
    t.decimal "discount", precision: 8, scale: 2, default: "0.0"
    t.decimal "total", precision: 8, scale: 2, default: "0.0"
    t.integer "billable_month"
    t.integer "billable_year"
    t.boolean "paid", default: false
    t.date "paid_at"
    t.boolean "fully_paid", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["billable_month", "billable_year"], name: "index_monthly_due_payments_on_billable_month_and_billable_year"
    t.index ["billable_month"], name: "index_monthly_due_payments_on_billable_month"
    t.index ["billable_year"], name: "index_monthly_due_payments_on_billable_year"
    t.index ["homeowner_id"], name: "index_monthly_due_payments_on_homeowner_id"
    t.index ["monthly_due_rate_id"], name: "index_monthly_due_payments_on_monthly_due_rate_id"
  end

  create_table "monthly_due_rates", force: :cascade do |t|
    t.decimal "amount", precision: 8, scale: 2, default: "400.0"
    t.date "start_date", default: "2018-01-01"
    t.date "end_date"
    t.boolean "recurring", default: true
    t.boolean "locked", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "streets", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position", default: 0
  end

  add_foreign_key "homeowners", "streets"
  add_foreign_key "monthly_due_payments", "homeowners"
  add_foreign_key "monthly_due_payments", "monthly_due_rates"
end
