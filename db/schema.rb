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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120211024219) do

  create_table "job_postings", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.text     "comments"
    t.string   "type"
    t.string   "contact"
    t.date     "deadline"
    t.string   "state"
    t.integer  "employer_id"
    t.string   "url"
    t.string   "affiliation"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "job_postings", ["employer_id"], :name => "index_job_postings_on_employer_id"

  create_table "job_postings_tags", :force => true do |t|
    t.integer "job_posting_id"
    t.integer "tag_id"
  end

  add_index "job_postings_tags", ["job_posting_id"], :name => "index_job_postings_tags_on_job_posting_id"
  add_index "job_postings_tags", ["tag_id"], :name => "index_job_postings_tags_on_tag_id"

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.string   "tagtype"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tags_users", :force => true do |t|
    t.integer "user_id"
    t.integer "tag_id"
  end

  add_index "tags_users", ["tag_id"], :name => "index_tags_users_on_tag_id"
  add_index "tags_users", ["user_id"], :name => "index_tags_users_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email",                  :default => "", :null => false
    t.string   "firstname"
    t.string   "lastname"
    t.string   "type"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "url"
    t.string   "affiliation"
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
