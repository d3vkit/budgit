# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100922073248) do

  create_table "bills", :force => true do |t|
    t.string   "name"
    t.string   "frequency"
    t.decimal  "amount"
    t.string   "day"
    t.integer  "year"
    t.integer  "month"
    t.integer  "weekday"
    t.string   "alternator"
    t.integer  "recurring_bill_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "occurs_once",       :default => false
    t.integer  "pay_period_id"
    t.boolean  "paid",              :default => false
  end

  create_table "funds", :force => true do |t|
    t.decimal  "amount"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "incomes", :force => true do |t|
    t.string   "name"
    t.string   "frequency"
    t.decimal  "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "weekday"
    t.integer  "recurring_income_id"
    t.string   "day"
    t.integer  "month"
    t.integer  "year"
    t.string   "alternator"
    t.string   "per"
    t.integer  "hours_worked"
    t.boolean  "occurs_once",         :default => false
    t.integer  "pay_period_id"
  end

  create_table "pay_periods", :force => true do |t|
    t.date     "begins"
    t.date     "ends"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "recurring_bills", :force => true do |t|
    t.string   "name"
    t.string   "frequency"
    t.decimal  "amount"
    t.integer  "year"
    t.integer  "month"
    t.string   "day"
    t.integer  "weekday"
    t.string   "alternator"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "recurring_incomes", :force => true do |t|
    t.string   "name"
    t.string   "frequency"
    t.decimal  "amount"
    t.integer  "year"
    t.integer  "month"
    t.string   "day"
    t.integer  "weekday"
    t.string   "alternator"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "per"
    t.integer  "hours_worked"
    t.boolean  "occurs_once",  :default => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "encrypted_password"
    t.boolean  "admin",              :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "salt"
    t.string   "remember_token"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
