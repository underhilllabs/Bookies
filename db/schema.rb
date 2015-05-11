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

ActiveRecord::Schema.define(version: 20150510205737) do

  create_table "bookmarks", force: :cascade do |t|
    t.string   "url",         limit: 2048
    t.string   "title",       limit: 255
    t.text     "desc",        limit: 65535
    t.datetime "created"
    t.datetime "modified"
    t.boolean  "private",     limit: 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",     limit: 4,     default: 1
    t.string   "hashed_url",  limit: 255
    t.string   "archive_url", limit: 255
    t.boolean  "is_archived", limit: 1
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   limit: 4,        default: 0, null: false
    t.integer  "attempts",   limit: 4,        default: 0, null: false
    t.text     "handler",    limit: 16777215
    t.text     "last_error", limit: 65535
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "followings", force: :cascade do |t|
    t.integer  "user_id",      limit: 4
    t.integer  "following_id", limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "identities", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.string   "email",           limit: 255
    t.string   "password_digest", limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "username",        limit: 255
    t.string   "nickname",        limit: 255
  end

  create_table "old_tags", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.integer  "bookmark_id", limit: 4
    t.datetime "created_at"
    t.integer  "user_id",     limit: 4,   default: 1
  end

  add_index "old_tags", ["bookmark_id"], name: "index_tags_on_bookmark_id", using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id",        limit: 4
    t.integer  "taggable_id",   limit: 4
    t.string   "taggable_type", limit: 255
    t.integer  "tagger_id",     limit: 4
    t.string   "tagger_type",   limit: 255
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name",           limit: 255
    t.integer "taggings_count", limit: 4,   default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "username",        limit: 255
    t.string   "email",           limit: 255
    t.string   "fullname",        limit: 255
    t.string   "website",         limit: 255
    t.text     "desc",            limit: 65535
    t.string   "website2",        limit: 255
    t.string   "website3",        limit: 255
    t.string   "pic_url",         limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "provider",        limit: 255
    t.string   "uid",             limit: 255
    t.string   "password_digest", limit: 255
  end

end
