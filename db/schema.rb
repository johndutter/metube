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

ActiveRecord::Schema.define(version: 20140410182404) do

  create_table "categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: true do |t|
    t.integer  "multimedia_id"
    t.integer  "parent_id"
    t.string   "text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",      default: 0, null: false
    t.integer  "attempts",      default: 0, null: false
    t.text     "handler",                   null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "multimedia_id"
    t.integer  "job_progress",  default: 0
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "messages", force: true do |t|
    t.integer  "user_id"
    t.string   "subject"
    t.text     "contents"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "recipient_name"
    t.boolean  "deleted_by_sender",    default: false
    t.boolean  "deleted_by_recipient", default: false
    t.boolean  "unread",               default: true
  end

  create_table "multimedia", force: true do |t|
    t.string   "title"
    t.integer  "views",          default: 0
    t.string   "mediaType"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.string   "path"
    t.string   "thumbnail_path"
    t.integer  "category_id"
  end

  create_table "playlist_entries", force: true do |t|
    t.integer  "playlist_id"
    t.integer  "multimedia_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "playlist_sentiments", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "playlist_id"
    t.boolean  "like"
  end

  create_table "playlists", force: true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "description"
    t.boolean  "public",      default: true
    t.integer  "views",       default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "count",       default: 0
  end

  create_table "sentiments", force: true do |t|
    t.integer  "user_id"
    t.integer  "multimedia_id"
    t.boolean  "like"
    t.boolean  "dislike"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subscriptions", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "subscription_id"
    t.integer  "user_id"
  end

  create_table "tags", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "multimedia_id"
    t.integer  "playlist_id"
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
    t.integer  "views",                                       default: 0
  end

end
