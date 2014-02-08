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

ActiveRecord::Schema.define(version: 20140208154733) do

  create_table "multimedia", force: true do |t|
    t.string   "title"
    t.integer  "views",       default: 0
    t.string   "mediaType"
    t.integer  "likes",       default: 0
    t.integer  "dislikes",    default: 0
    t.string   "tags"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
  end

  create_table "users", force: true do |t|
    t.string   "username"
    t.string   "salt"
    t.string   "encrypted_password"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
    t.decimal  "iterations",         precision: 10, scale: 0
    t.string   "firstname"
    t.string   "lastname"
    t.string   "phone"
  end

end
