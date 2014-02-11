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

ActiveRecord::Schema.define(version: 20140211182806) do

  create_table "multimedia", force: true do |t|
    t.string   "title"
    t.integer  "views",          default: 0
    t.string   "mediaType"
    t.integer  "likes",          default: 0
    t.integer  "dislikes",       default: 0
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.string   "path"
    t.string   "thumbnail_path"
  end

  create_table "tags", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags_to_multimedia", force: true do |t|
    t.integer  "tag_id"
    t.integer  "multimedia_id"
    t.datetime "created_at"
    t.datetime "updated_at"
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
