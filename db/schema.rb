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

ActiveRecord::Schema.define(version: 20141215163057) do

  create_table "bookmarks", force: true do |t|
    t.string   "url",         limit: 2048
    t.string   "title"
    t.text     "desc"
    t.datetime "created"
    t.datetime "modified"
    t.boolean  "private"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "user_id",                  default: 1
    t.string   "hashed_url"
    t.string   "archive_url"
    t.boolean  "is_archived"
  end

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",                    default: 0, null: false
    t.integer  "attempts",                    default: 0, null: false
    t.text     "handler",    limit: 16777215
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "followings", force: true do |t|
    t.integer  "user_id"
    t.integer  "following_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "identities", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "username"
    t.string   "nickname"
  end

  create_table "tags", force: true do |t|
    t.string   "name"
    t.integer  "bookmark_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "user_id",     default: 1
  end

  add_index "tags", ["bookmark_id"], name: "index_tags_on_bookmark_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "fullname"
    t.string   "website"
    t.text     "desc"
    t.string   "website2"
    t.string   "website3"
    t.string   "pic_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "provider"
    t.string   "uid"
  end

end
