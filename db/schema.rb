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

ActiveRecord::Schema.define(version: 20131104020100) do

  create_table "bus_lines", force: true do |t|
    t.integer  "line_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bus_lines", ["line_number"], name: "index_bus_lines_on_line_number", unique: true, using: :btree

  create_table "buses", force: true do |t|
    t.integer  "bus_plate"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "bus_line_id"
  end

  add_index "buses", ["bus_plate"], name: "index_buses_on_bus_plate", unique: true, using: :btree

  create_table "tickets", force: true do |t|
    t.integer  "ticket_type"
    t.string   "uuid"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tickets", ["uuid"], name: "index_tickets_on_uuid", unique: true, using: :btree

  create_table "used_tickets", force: true do |t|
    t.datetime "date_used"
    t.integer  "ticket_type"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "bus_id"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "pw"
    t.string   "token"
    t.datetime "expirationDate"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
