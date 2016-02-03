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

ActiveRecord::Schema.define(version: 20160131230903) do

  create_table "researcher_rankings", force: true do |t|
    t.integer  "search_id"
    t.integer  "researcher_id"
    t.boolean  "result_1"
    t.boolean  "result_2"
    t.boolean  "result_3"
    t.boolean  "result_4"
    t.boolean  "result_5"
    t.boolean  "result_6"
    t.boolean  "result_7"
    t.boolean  "result_8"
    t.boolean  "result_9"
    t.boolean  "result_10"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "researchers", force: true do |t|
    t.string   "email"
    t.string   "name"
    t.string   "university"
    t.string   "position"
    t.integer  "search_group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "search_groups", force: true do |t|
    t.integer  "search_group_id"
    t.integer  "search_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "search_results", force: true do |t|
    t.integer  "search_id"
    t.string   "result_title"
    t.string   "result_journal"
    t.string   "result_publication_year"
    t.string   "result_start_page"
    t.string   "result_end_page"
    t.string   "result_authors"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "searches", force: true do |t|
    t.integer  "search_id"
    t.string   "search_phrase"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
